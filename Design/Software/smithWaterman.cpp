#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

const int matchScore = 1;
const int mismatchPenalty = -1;
const int gapPenalty = -2;

void smithWaterman(const string& seq1, const string& seq2) {
    int rows = seq1.length() + 1;
    int cols = seq2.length() + 1;

    vector<vector<int>> scoreMatrix(rows, vector<int>(cols, 0));
    vector<vector<char>> traceback(rows, vector<char>(cols, '0'));

    int maxScore = 0;
    int maxI = 0, maxJ = 0;

    for (int i = 1; i < rows; ++i) {
        for (int j = 1; j < cols; ++j) {
            int match = scoreMatrix[i - 1][j - 1] + (seq1[i - 1] == seq2[j - 1] ? matchScore : mismatchPenalty);
            int gapSeq1 = scoreMatrix[i - 1][j] + gapPenalty;
            int gapSeq2 = scoreMatrix[i][j - 1] + gapPenalty;

            int score = max(0, max({ match, gapSeq1, gapSeq2 }));
            scoreMatrix[i][j] = score;

            if (score > maxScore) {
                maxScore = score;
                maxI = i;
                maxJ = j;
            }

            if (score == 0)
                traceback[i][j] = '0';
            else if (score == match)
                traceback[i][j] = '\\';
            else if (score == gapSeq1)
                traceback[i][j] = '|';
            else
                traceback[i][j] = '-';
        }
    }

    // Traceback to find the aligned sequences
    string alignedSeq1, alignedSeq2;
    int i = maxI, j = maxJ;

    while (i > 0 && j > 0 && scoreMatrix[i][j] != 0) {
        if (traceback[i][j] == '\\') {
            alignedSeq1 = seq1[i - 1] + alignedSeq1;
            alignedSeq2 = seq2[j - 1] + alignedSeq2;
            --i;
            --j;
        } else if (traceback[i][j] == '|') {
            alignedSeq1 = seq1[i - 1] + alignedSeq1;
            alignedSeq2 = '-' + alignedSeq2;
            --i;
        } else if (traceback[i][j] == '-') {
            alignedSeq1 = '-' + alignedSeq1;
            alignedSeq2 = seq2[j - 1] + alignedSeq2;
            --j;
        }
    }

    cout << "Alignment Score: " << maxScore << endl;
    cout << "Aligned Sequence 1: " << alignedSeq1 << endl;
    cout << "Aligned Sequence 2: " << alignedSeq2 << endl;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        cerr << "Usage: " << argv[0] << " <sequence1> <sequence2>" << endl;
        return 1;
    }

    string seq1(argv[1]);
    string seq2(argv[2]);

    smithWaterman(seq1, seq2);

    return 0;
}

