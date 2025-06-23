#include <iostream>
#include <fstream>
#include <vector>
#include <bitset>
#include <string>
#include <cstdlib>

using namespace std;

// 將 "01101011" 這種 8-bit 字串轉成 signed int8_t
int8_t binaryStringToInt8(const string& binStr) {
    bitset<8> bs(binStr);
    uint8_t u = static_cast<uint8_t>(bs.to_ulong());
    // 最高位若為 1，代表負數
    return (u & 0x80) ? static_cast<int8_t>(u - 0x100)
                      : static_cast<int8_t>(u);
}

// 讀取一張 rows×cols 的 .dat（每行一個 8-bit 字串）
vector<vector<int8_t>> readDatFile(const string& fn, int rows, int cols) {
    ifstream in(fn);
    if (!in) {
        cerr << "Cannot open " << fn << "\n";
        exit(1);
    }
    vector<vector<int8_t>> M(rows, vector<int8_t>(cols));
    string line;
    int cnt = 0;
    while (getline(in, line) && cnt < rows*cols) {
        if (line.size() != 8) continue;
        int r = cnt / cols, c = cnt % cols;
        M[r][c] = binaryStringToInt8(line);
        ++cnt;
    }
    if (cnt < rows*cols)
        cerr << "Warning: only read " << cnt << " entries from " << fn << "\n";
    return M;
}

// valid 2D convolution (no padding, no stride)
vector<vector<int>> convolve2D(const vector<vector<int8_t>>& in,
                               const vector<vector<int8_t>>& kw) {
    int R = in.size(), C = in[0].size();
    int r = kw.size(), c = kw[0].size();
    int Ro = R - r + 1, Co = C - c + 1;
    vector<vector<int>> out(Ro, vector<int>(Co,0));
    for (int i = 0; i < Ro; ++i) {
        for (int j = 0; j < Co; ++j) {
            int sum = 0;
            for (int y = 0; y < r; ++y)
                for (int x = 0; x < c; ++x)
                    sum += int(in[i+y][j+x]) * int(kw[y][x]);
            out[i][j] = sum;
        }
    }
    return out;
}

// 取消最低 5 bits
void removeLowest5Bits(vector<vector<int>>& M) {
    for (auto & row : M)
        for (auto & v : row)
            v >>= 5; 
}

// 印整個矩陣
template<typename T>
void printMatrix(const vector<vector<T>>& M) {
    for (auto& row : M) {
        for (auto& v : row)
            cout << v << "\t";
        cout << "\n";
    }
}

int main(){
    int R, C, r, c;
    // 1. 向使用者詢問維度
    cout << "Enter IFM rows and cols: ";
    cin >> R >> C;
    cout << "Enter kernel rows and cols: ";
    cin >> r >> c;

    // 2. 檔名固定或可改成從 cin 讀取
    string ifm1_fn = "IFM_8x8_1.dat";
    string ifm2_fn = "IFM_8x8_2.dat";

    vector<string> kw_fn;
    if (r == 3 && c == 3) {
        kw_fn = {
            "KW_3x3_1.dat", "KW_3x3_2.dat", "KW_3x3_3.dat", "KW_3x3_4.dat"
        };
    } else if (r == 5 && c == 5) {
        kw_fn = {
            "KW_5x5_1.dat", "KW_5x5_2.dat", "KW_5x5_3.dat", "KW_5x5_4.dat"
        };
    } else {
        cerr << "Unsupported kernel size: " << r << "x" << c << "\n";
        return 1;
    }

    // 3. 讀兩張 IFM
    auto IFM1 = readDatFile(ifm1_fn, R, C);
    auto IFM2 = readDatFile(ifm2_fn, R, C);

    // 4. 讀四張 KW
    vector<vector<vector<int8_t>>> KW(4);
    for (int i = 0; i < 4; ++i)
        KW[i] = readDatFile(kw_fn[i], r, c);

    // 5. 分別做兩組「雙通道卷積」
    //    OFM1 = IFM1*KW[0] + IFM2*KW[1]
    //    OFM2 = IFM1*KW[2] + IFM2*KW[3]
    // 這裡先各自算出兩張 single‐channel conv，再加總
    auto conv11 = convolve2D(IFM1, KW[0]);
    auto conv12 = convolve2D(IFM2, KW[1]);
    auto conv21 = convolve2D(IFM1, KW[2]);
    auto conv22 = convolve2D(IFM2, KW[3]);

    int Ro = R - r + 1, Co = C - c + 1;
    vector<vector<int>> OFM1(Ro, vector<int>(Co)),
                        OFM2(Ro, vector<int>(Co));
    for (int i = 0; i < Ro; ++i){
        for (int j = 0; j < Co; ++j){
            OFM1[i][j] = conv11[i][j] + conv12[i][j];
            OFM2[i][j] = conv21[i][j] + conv22[i][j];
        }
    }

    // 6. 取消最低 4 bits
    removeLowest5Bits(OFM1);
    removeLowest5Bits(OFM2);

    // 7. 印出結果
    cout << "\n=== OFM1 ===\n";
    printMatrix(OFM1);
    cout << "\n=== OFM2 ===\n";
    printMatrix(OFM2);

    return 0;
}
