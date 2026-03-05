# Neural Trial-Type Decoding

## Overview
Parviz Ghaderi (Carl Petersen lab, EPFL) recorded mouse neural activity and behavior across multiple sessions and trials. Each 3-second trial contains combinations of auditory tones and whisker deflections plus a possible lick response; rewards are delivered when the lick matches the required contingency. The goal is to predict the trial type (stimuli + lick response) from neural activity.

## Experiment Setup
- 5 brain areas: A1, ALM, wS1, wS2, wM2
- Layers vary by region (e.g., L1, L2/3, L4, L5, L6a, L6b)
- Two neuron types: EXC (excitatory) and INH (inhibitory)
- 30 time bins (100 ms each) per region-layer-celltype combination
- Sessions → trials (3 s) → stimuli (tone/whisker) → lick response → reward

![Experiment setup](images/experiment_setup.png)
![Recorded brain areas](images/brain_areas.png)
![Neural Systems](images/motor_processing.png)

## Data
- train.csv — trials with labels (`TRIAL_TYPE`)
- test.csv — trials without labels (predict here)
- sample_submission.csv — template for competition submissions

Columns include `session_id`, `trial_number`, neural features named like `ALM_L1_EXC_time_13` (mean spikes for that population and 100 ms bin), and `TRIAL_TYPE` (e.g., `NOGO W+ nolick`).

## Repository Guide
- **notebooks/final_submission.ipynb** — Complete pipeline: visualization, preprocessing, modeling, and final submission
- **data/processed/** — Generated preprocessing outputs (RFE features, transforms)
- **data/submission_nonlinear/** — Final submission CSV

## 1. Data Visualization
Distribution of trial types, neural activity heatmaps by region/layer/cell-type, time series plots, and feature correlations.

## 2. Preprocessing
1. Drop all-NaN columns → Median imputation for remaining NaNs
2. **Session-wise Z-score normalization** (+14% accuracy gain)
3. **RFE feature selection** (1380 → 120 features) using Random Forest importance
4. **6-class remapping**: Merge lick/nolick variants to reduce class imbalance

## 3. Models
- **Linear**: Ridge, Lasso, Logistic Regression, LDA (~55% LOSO accuracy)
- **Non-linear**: Random Forest, XGBoost, HistGradientBoosting (~58-59%)
- **Ensemble**: VotingClassifier (4×RF + 1×LDA) with soft voting (~60%)
- **Final**: Per-mouse + global hybrid weighting based on LOSO performance

**Kaggle submission**: 61.5% accuracy

**Key findings**:
- Session normalization is critical (+14% gain)
- Whisker prediction (W+/W-) is easier than auditory (GO/NOGO/notone)
- Per-mouse models help for mice with more training data (PG082)
- Auditory tone distinction is hardest to predict

## Labels (TRIAL_TYPE)
- Tone: GO, NOGO, no tone
- Whisker: W+, W−
- Lick response: lick, nolick
- Combination example: `NOGO W+ nolick`.


![Reward contingencies](images/reward_contions.png)

## Quick Start

### Option 1: Docker (Recommended for Reproducibility)

**Prerequisites:** [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)

```bash
git clone https://github.com/milorsanders/BIO-322.git
cd BIO-322
docker-compose up
```
Open http://localhost:8888 in your browser (no token required).

**What's included:**
- Python 3.10 with NumPy, Pandas, Scikit-learn, XGBoost, Matplotlib, Seaborn
- Jupyter Notebook with all dependencies pre-installed

**Volume mounts:** `data/`, `notebooks/`, and `images/` are mounted, so changes persist on your host machine.

### Option 2: uv (Fast Python Package Manager)
```bash
# Windows
.\setup.ps1

# Linux/Mac
chmod +x setup.sh && ./setup.sh
```

### Option 3: Manual Setup
```bash
# Install uv if not present
curl -LsSf https://astral.sh/uv/install.sh | sh  # Linux/Mac
# or: powershell -c "irm https://astral.sh/uv/install.ps1 | iex"  # Windows

# Create environment and install
uv venv .venv
uv pip install -e .
source .venv/bin/activate  # or .venv\Scripts\activate on Windows

# Run the main notebook
jupyter notebook notebooks/final_submission.ipynb
```

## Project Structure
```
BIO-322/
├── data/
│   ├── train.csv              # Training data with labels
│   ├── test.csv               # Test data (predict here)
│   ├── processed/             # Generated preprocessing outputs
│   ├── submission_linear/     # Linear model submission
│   └── submission_nonlinear/  # Best submission (hybrid)
├── notebooks/
│   └── final_submission.ipynb # Complete pipeline (run this!)
├── images/                    # Experiment diagrams
├── pyproject.toml             # Python dependencies (uv/pip)
├── Dockerfile                 # Docker containerization
├── docker-compose.yml         # Docker orchestration
├── setup.ps1                  # Windows setup script
└── setup.sh                   # Linux/Mac setup script
```

## Reproducing Results

The main notebook `notebooks/final_submission.ipynb` contains the complete pipeline:
1. **Data Inspection** - Visualizations of neural activity patterns
2. **Preprocessing** - Session normalization, RFE feature selection (120 features)
3. **Linear Models** - Ridge, Lasso, LDA baselines
4. **Non-Linear Models** - Hybrid per-mouse + global ensemble (61.5% Kaggle accuracy)
5. **Summary** - Analysis and conclusions

Run all cells in order to regenerate the final submission from raw data.

## Main Outputs

**Processed Data:**
- `data/processed/X_train_rfe.csv` - RFE-selected features (120)
- `data/processed/X_test_rfe.csv` - Test features
- `data/processed/transforms.joblib` - Saved preprocessing pipeline

**Submissions:**
- `data/submission_nonlinear/corrected_weighted_hybrid_submission.csv` - Best submission (61.5% LOSO)

## License
This repository is for coursework. If you plan to reuse the data or code, please check with the owner.
