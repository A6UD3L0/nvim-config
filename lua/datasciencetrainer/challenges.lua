-- DataScienceTrainer Challenges
-- Progressive learning path for data science in Neovim

local M = {}

-- Challenge categories from basic to advanced
M.categories = {
  "basics",        -- Basic Python and data structure operations
  "numpy",         -- NumPy array operations
  "pandas",        -- Data manipulation with Pandas
  "visualization", -- Data visualization with matplotlib/seaborn
  "ml",            -- Machine learning with scikit-learn
  "advanced",      -- Advanced topics (NLP, Deep Learning, etc.)
}

-- Challenge difficulty levels
M.levels = {
  "beginner",
  "intermediate",
  "advanced",
  "expert",
}

-- Challenge structure:
-- id: Unique identifier
-- title: Short descriptive title
-- description: Detailed explanation of the challenge
-- task: What the user needs to do
-- hints: Array of progressive hints
-- solution: Example solution code
-- expected_output: What to expect when code runs correctly
-- setup_code: Code to run before the challenge (if needed)
-- category: Which category this belongs to
-- level: Difficulty level
-- type: "code" or "quiz" or "workflow"
-- dependencies: Required Python packages

-- Basic Python and data structures challenges
M.basics = {
  {
    id = "variables",
    title = "Python Variables",
    description = "Let's start with basic Python variables and printing to output.",
    task = "Create a variable named 'data_science' with the value 'awesome' and print it.",
    hints = {
      "Use the assignment operator (=) to create a variable",
      "Use the print() function to display output",
    },
    solution = "data_science = 'awesome'\nprint(data_science)",
    expected_output = "awesome",
    category = "basics",
    level = "beginner",
    type = "code",
    dependencies = {},
  },
  {
    id = "lists",
    title = "Working with Lists",
    description = "Lists are fundamental data structures in Python for data science.",
    task = "Create a list of numbers 1-5, then calculate and print their sum and average.",
    hints = {
      "You can create a list with square brackets: numbers = [1, 2, 3, 4, 5]",
      "Use sum() to calculate the total",
      "Divide by len(numbers) to get the average",
    },
    solution = "numbers = [1, 2, 3, 4, 5]\ntotal = sum(numbers)\naverage = total / len(numbers)\nprint(f'Sum: {total}, Average: {average}')",
    expected_output = "Sum: 15, Average: 3.0",
    category = "basics",
    level = "beginner",
    type = "code",
    dependencies = {},
  },
  {
    id = "dictionaries",
    title = "Dictionary Manipulation",
    description = "Dictionaries are key-value stores that are commonly used in data processing.",
    task = "Create a dictionary of three countries and their capitals, then print only the capitals.",
    hints = {
      "Create a dictionary with curly braces: countries = {'USA': 'Washington D.C.'}",
      "Use dict.values() to get only the values",
    },
    solution = "countries = {'USA': 'Washington D.C.', 'France': 'Paris', 'Japan': 'Tokyo'}\nprint(list(countries.values()))",
    expected_output = "['Washington D.C.', 'Paris', 'Tokyo']",
    category = "basics",
    level = "beginner",
    type = "code",
    dependencies = {},
  },
  {
    id = "list_comprehension",
    title = "List Comprehensions",
    description = "List comprehensions provide a concise way to create lists, which is very useful in data processing.",
    task = "Create a list of squares for numbers 1-10 using a list comprehension.",
    hints = {
      "List comprehension syntax: [expression for item in iterable]",
      "You can use range(1, 11) to get numbers 1-10",
    },
    solution = "squares = [x**2 for x in range(1, 11)]\nprint(squares)",
    expected_output = "[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]",
    category = "basics", 
    level = "intermediate",
    type = "code",
    dependencies = {},
  },
  {
    id = "functions",
    title = "Creating Functions",
    description = "Functions help organize code and make it reusable, which is essential for complex data analysis.",
    task = "Create a function called 'calculate_stats' that takes a list of numbers and returns their min, max, and average as a tuple.",
    hints = {
      "Define a function with def calculate_stats(numbers):",
      "Use min(), max(), and sum()/len() to calculate the statistics",
      "Return them as a tuple with return (min_val, max_val, avg)",
    },
    solution = "def calculate_stats(numbers):\n    min_val = min(numbers)\n    max_val = max(numbers)\n    avg = sum(numbers) / len(numbers)\n    return (min_val, max_val, avg)\n\ndata = [4, 2, 7, 5, 9]\nprint(calculate_stats(data))",
    expected_output = "(2, 9, 5.4)",
    category = "basics",
    level = "intermediate",
    type = "code",
    dependencies = {},
  },
}

-- NumPy challenges
M.numpy = {
  {
    id = "numpy_arrays",
    title = "Creating NumPy Arrays",
    description = "NumPy arrays are the foundation of data manipulation in Python.",
    task = "Import NumPy, create a 3x3 array of random integers between 1 and 10, and print it.",
    hints = {
      "Import numpy with: import numpy as np",
      "Use np.random.randint(low, high, size=(rows, cols))",
    },
    solution = "import numpy as np\nnp.random.seed(42)  # For reproducibility\narray = np.random.randint(1, 11, size=(3, 3))\nprint(array)",
    expected_output = "array",  -- Just check if output contains "array"
    setup_code = "pip install numpy",
    category = "numpy",
    level = "beginner",
    type = "code",
    dependencies = {"numpy"},
  },
  {
    id = "numpy_operations",
    title = "Array Operations",
    description = "Performing mathematical operations on arrays is much faster with NumPy.",
    task = "Create a 1D array of numbers 1-10, then calculate and print the square root of each element.",
    hints = {
      "Use np.arange(1, 11) to create a 1D array of numbers 1-10",
      "Use np.sqrt() to calculate square roots",
    },
    solution = "import numpy as np\nnumbers = np.arange(1, 11)\nsqrt_values = np.sqrt(numbers)\nprint(sqrt_values)",
    expected_output = "[1.         1.41421356 1.73205081 2.         2.23606798 2.44948974\n 2.64575131 2.82842712 3.         3.16227766]",
    category = "numpy",
    level = "beginner",
    type = "code",
    dependencies = {"numpy"},
  },
  {
    id = "array_slicing",
    title = "Array Slicing and Indexing",
    description = "Extracting specific data from arrays is a common operation in data analysis.",
    task = "Create a 5x5 matrix of values 0-24, then extract and print the central 3x3 submatrix.",
    hints = {
      "Use np.arange(25).reshape(5, 5) to create the matrix",
      "Use array slicing with [start:end, start:end]",
    },
    solution = "import numpy as np\nmatrix = np.arange(25).reshape(5, 5)\ncenter = matrix[1:4, 1:4]\nprint(center)",
    expected_output = "[[ 6  7  8]\n [11 12 13]\n [16 17 18]]",
    category = "numpy",
    level = "intermediate",
    type = "code",
    dependencies = {"numpy"},
  },
}

-- Pandas challenges
M.pandas = {
  {
    id = "pandas_series",
    title = "Creating Pandas Series",
    description = "Pandas Series are 1D labeled arrays, fundamental for data analysis.",
    task = "Create a Pandas Series of 5 different fruits with custom indices (a-e), then print it.",
    hints = {
      "Import pandas with: import pandas as pd",
      "Create a Series with: pd.Series(data=values, index=indices)",
    },
    solution = "import pandas as pd\nfruits = pd.Series(['apple', 'banana', 'cherry', 'date', 'elderberry'], index=['a', 'b', 'c', 'd', 'e'])\nprint(fruits)",
    expected_output = "a          apple\nb         banana\nc         cherry\nd           date\ne    elderberry\ndtype: object",
    setup_code = "pip install pandas",
    category = "pandas",
    level = "beginner",
    type = "code",
    dependencies = {"pandas"},
  },
  {
    id = "pandas_dataframe",
    title = "Creating DataFrames",
    description = "DataFrames are 2D labeled data structures and the most commonly used Pandas object.",
    task = "Create a DataFrame with 3 columns (Name, Age, City) and 3 rows of sample data, then print it.",
    hints = {
      "Create a DataFrame from a dictionary of lists",
      "Each key is a column name, and the list is the column data",
    },
    solution = "import pandas as pd\ndata = {\n    'Name': ['Alice', 'Bob', 'Charlie'],\n    'Age': [25, 30, 35],\n    'City': ['New York', 'San Francisco', 'Los Angeles']\n}\ndf = pd.DataFrame(data)\nprint(df)",
    expected_output = "      Name  Age           City\n0    Alice   25       New York\n1      Bob   30  San Francisco\n2  Charlie   35    Los Angeles",
    category = "pandas",
    level = "beginner",
    type = "code",
    dependencies = {"pandas"},
  },
  {
    id = "data_filtering",
    title = "Data Filtering",
    description = "Filtering data is a common task in data analysis.",
    task = "Create a DataFrame of 5 students with columns for Name, Age, and Score. Filter and print only students with scores above 80.",
    hints = {
      "Create a DataFrame with sample student data",
      "Use Boolean indexing with df[df['Score'] > 80]",
    },
    solution = "import pandas as pd\ndata = {\n    'Name': ['Alice', 'Bob', 'Charlie', 'David', 'Eve'],\n    'Age': [20, 21, 19, 22, 20],\n    'Score': [85, 75, 90, 65, 95]\n}\ndf = pd.DataFrame(data)\nhigh_scorers = df[df['Score'] > 80]\nprint(high_scorers)",
    expected_output = "      Name  Age  Score\n0    Alice   20     85\n2  Charlie   19     90\n4      Eve   20     95",
    category = "pandas",
    level = "intermediate",
    type = "code",
    dependencies = {"pandas"},
  },
}

-- Visualization challenges
M.visualization = {
  {
    id = "basic_plot",
    title = "Basic Plotting",
    description = "Visualization is crucial for understanding data patterns.",
    task = "Create a simple line plot of sine wave values from 0 to 2π, with proper labels and title.",
    hints = {
      "Import matplotlib.pyplot as plt and numpy as np",
      "Create x values with np.linspace(0, 2*np.pi, 100)",
      "Calculate y values with np.sin(x)",
      "Use plt.plot(), plt.xlabel(), plt.ylabel(), and plt.title()",
    },
    solution = "import numpy as np\nimport matplotlib.pyplot as plt\n\nx = np.linspace(0, 2*np.pi, 100)\ny = np.sin(x)\n\nplt.figure(figsize=(8, 4))\nplt.plot(x, y)\nplt.xlabel('Angle (radians)')\nplt.ylabel('Sine value')\nplt.title('Sine Wave')\nplt.grid(True)\n\n# In Neovim, we can't display the plot directly, but we can save it\nplt.savefig('/tmp/sine_wave.png')\nprint('Plot created successfully!')",
    expected_output = "Plot created successfully!",
    setup_code = "pip install matplotlib",
    category = "visualization",
    level = "beginner",
    type = "code",
    dependencies = {"numpy", "matplotlib"},
  },
  {
    id = "multiple_plots",
    title = "Multiple Plots",
    description = "Comparing multiple data series in one visualization.",
    task = "Create a figure with 2 subplots: a sine wave and a cosine wave from 0 to 2π.",
    hints = {
      "Use plt.subplots(2, 1) to create 2 vertically stacked subplots",
      "Plot sine on the first subplot and cosine on the second",
      "Add appropriate labels and titles",
    },
    solution = "import numpy as np\nimport matplotlib.pyplot as plt\n\nx = np.linspace(0, 2*np.pi, 100)\n\nfig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 6))\n\n# Plot sine on first subplot\nax1.plot(x, np.sin(x), 'b-')\nax1.set_title('Sine Wave')\nax1.set_ylabel('Amplitude')\nax1.grid(True)\n\n# Plot cosine on second subplot\nax2.plot(x, np.cos(x), 'r-')\nax2.set_title('Cosine Wave')\nax2.set_xlabel('Angle (radians)')\nax2.set_ylabel('Amplitude')\nax2.grid(True)\n\nplt.tight_layout()\nplt.savefig('/tmp/sine_cosine.png')\nprint('Multiple plots created successfully!')",
    expected_output = "Multiple plots created successfully!",
    category = "visualization",
    level = "intermediate",
    type = "code",
    dependencies = {"numpy", "matplotlib"},
  },
}

-- Machine Learning challenges
M.ml = {
  {
    id = "train_test_split",
    title = "Train-Test Split",
    description = "Splitting data into training and testing sets is a fundamental step in machine learning.",
    task = "Load the iris dataset from scikit-learn, split it into training (80%) and testing (20%) sets, and print their shapes.",
    hints = {
      "Import datasets from sklearn to load the iris dataset",
      "Use train_test_split from sklearn.model_selection",
      "Print the shapes of X_train, X_test, y_train, y_test",
    },
    solution = "from sklearn import datasets\nfrom sklearn.model_selection import train_test_split\n\n# Load the iris dataset\niris = datasets.load_iris()\nX = iris.data\ny = iris.target\n\n# Split into train and test sets\nX_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)\n\n# Print the shapes\nprint(f'X_train shape: {X_train.shape}')\nprint(f'X_test shape: {X_test.shape}')\nprint(f'y_train shape: {y_train.shape}')\nprint(f'y_test shape: {y_test.shape}')",
    expected_output = "X_train shape: (120, 4)\nX_test shape: (30, 4)\ny_train shape: (120,)\ny_test shape: (30,)",
    setup_code = "pip install scikit-learn",
    category = "ml",
    level = "beginner",
    type = "code",
    dependencies = {"scikit-learn"},
  },
  {
    id = "simple_classifier",
    title = "Training a Simple Classifier",
    description = "Let's train a basic machine learning model to classify data.",
    task = "Load the iris dataset, split it into train/test sets, train a Decision Tree classifier, and print its accuracy.",
    hints = {
      "Use DecisionTreeClassifier from sklearn.tree",
      "Fit the model on the training data with model.fit(X_train, y_train)",
      "Calculate accuracy with model.score(X_test, y_test)",
    },
    solution = "from sklearn import datasets\nfrom sklearn.model_selection import train_test_split\nfrom sklearn.tree import DecisionTreeClassifier\n\n# Load the iris dataset\niris = datasets.load_iris()\nX = iris.data\ny = iris.target\n\n# Split into train and test sets\nX_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)\n\n# Create and train the classifier\nmodel = DecisionTreeClassifier(random_state=42)\nmodel.fit(X_train, y_train)\n\n# Evaluate the model\naccuracy = model.score(X_test, y_test)\nprint(f'Model accuracy: {accuracy:.4f}')",
    expected_output = "Model accuracy: 0.9",
    category = "ml",
    level = "intermediate",
    type = "code",
    dependencies = {"scikit-learn"},
  },
}

-- Advanced challenges
M.advanced = {
  {
    id = "text_processing",
    title = "NLP Text Processing",
    description = "Natural Language Processing is an important field in data science.",
    task = "Use NLTK to tokenize a sentence, remove stopwords, and print the result.",
    hints = {
      "Import nltk and download the necessary packages",
      "Use word_tokenize to split the sentence into tokens",
      "Remove stopwords using a list comprehension",
    },
    solution = "import nltk\nimport ssl\n\ntry:\n    _create_unverified_https_context = ssl._create_unverified_context\nexcept AttributeError:\n    pass\nelse:\n    ssl._create_default_https_context = _create_unverified_https_context\n\nnltk.download('punkt', quiet=True)\nnltk.download('stopwords', quiet=True)\n\nfrom nltk.tokenize import word_tokenize\nfrom nltk.corpus import stopwords\n\n# Input text\ntext = \"Natural language processing is an exciting field in data science and artificial intelligence.\"\n\n# Tokenize\ntokens = word_tokenize(text)\n\n# Remove stopwords\nstop_words = set(stopwords.words('english'))\nfiltered_tokens = [word for word in tokens if word.lower() not in stop_words]\n\nprint(filtered_tokens)",
    expected_output = "['Natural', 'language', 'processing', 'exciting', 'field', 'data', 'science', 'artificial', 'intelligence', '.']",
    setup_code = "pip install nltk",
    category = "advanced",
    level = "intermediate",
    type = "code",
    dependencies = {"nltk"},
  },
  {
    id = "advanced_workflow",
    title = "Complete Data Science Workflow",
    description = "Integrate data loading, processing, visualization, and modeling in a complete workflow.",
    task = "Load a dataset, perform EDA, preprocess the data, train a model, evaluate it, and visualize the results.",
    hints = {
      "This is a multi-step process - take it step by step",
      "Use pandas for data loading and manipulation",
      "Use matplotlib/seaborn for visualization",
      "Use scikit-learn for preprocessing and modeling",
    ],
    solution = "import pandas as pd\nimport numpy as np\nimport matplotlib.pyplot as plt\nfrom sklearn.datasets import load_wine\nfrom sklearn.model_selection import train_test_split\nfrom sklearn.preprocessing import StandardScaler\nfrom sklearn.ensemble import RandomForestClassifier\nfrom sklearn.metrics import classification_report, confusion_matrix\nimport seaborn as sns\n\n# Load dataset\nwine = load_wine()\nX = pd.DataFrame(wine.data, columns=wine.feature_names)\ny = wine.target\n\n# Quick EDA\nprint(f\"Dataset shape: {X.shape}\")\nprint(f\"Target classes: {np.unique(y)}\")\n\n# See correlation between features\nplt.figure(figsize=(12, 10))\ncorr = X.corr()\nmask = np.triu(np.ones_like(corr, dtype=bool))\nsns.heatmap(corr, mask=mask, annot=False, cmap='coolwarm')\nplt.title('Feature Correlation Heatmap')\nplt.savefig('/tmp/correlation.png')\n\n# Split data\nX_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)\n\n# Scale features\nscaler = StandardScaler()\nX_train_scaled = scaler.fit_transform(X_train)\nX_test_scaled = scaler.transform(X_test)\n\n# Train model\nmodel = RandomForestClassifier(n_estimators=100, random_state=42)\nmodel.fit(X_train_scaled, y_train)\n\n# Evaluate\ny_pred = model.predict(X_test_scaled)\nprint(\"\\nClassification Report:\")\nprint(classification_report(y_test, y_pred))\n\n# Visualize feature importance\nfeature_importance = pd.DataFrame(\n    {'Feature': X.columns, 'Importance': model.feature_importances_}\n).sort_values('Importance', ascending=False)\n\nplt.figure(figsize=(10, 6))\nsns.barplot(x='Importance', y='Feature', data=feature_importance[:10])\nplt.title('Top 10 Feature Importance')\nplt.savefig('/tmp/feature_importance.png')\n\nprint(\"\\nComplete data science workflow executed successfully!\")",
    expected_output = "Complete data science workflow executed successfully!",
    setup_code = "pip install pandas numpy matplotlib seaborn scikit-learn",
    category = "advanced",
    level = "expert",
    type = "code",
    dependencies = {"pandas", "numpy", "matplotlib", "seaborn", "scikit-learn"},
  },
}

-- Get all challenges for a specific category and level
function M.get_challenges(category, level)
  if not M[category] then
    return {}
  end
  
  if level then
    return vim.tbl_filter(function(challenge)
      return challenge.level == level
    end, M[category])
  else
    return M[category]
  end
end

-- Get a specific challenge by ID
function M.get_challenge_by_id(id)
  for _, category in ipairs(M.categories) do
    if M[category] then
      for _, challenge in ipairs(M[category]) do
        if challenge.id == id then
          return challenge
        end
      end
    end
  end
  
  return nil
end

return M
