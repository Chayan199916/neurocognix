# NeuroCognix

NeuroCognix is an advanced cognitive training mobile application that enhances users' memory and cognitive skills through engaging word sequence challenges. Leveraging machine learning, natural language processing, and adaptive learning technologies, NeuroCognix tailors each experience to individual users, adapting difficulty levels in real time for a truly personalized cognitive training experience.

---

## 🚀 Features

### 🔹 Core Functionalities

- **Adaptive Difficulty System**: Automatically adjusts difficulty based on user performance.
- **Real-Time Cognitive Load Monitoring**: Detects and responds to mental fatigue and engagement.
- **Multi-Category Word Challenges**: Includes a range of word categories for varied learning.
- **Semantic Similarity Checking**: Utilizes NLP to recognize word relations.
- **Performance Analytics & Tracking**: Provides in-depth performance insights.
- **Personalized User Profiling**: Adjusts challenges based on user profile and cognitive state.

### 🔹 Smart Adaptation

- **Profile-Based Difficulty Adjustment**: Tailors difficulty using user profiles.
- **Fatigue Detection & Management**: Adapts gameplay to maintain user engagement.
- **Dynamic Timing System**: Adjusts timing based on individual performance.
- **Educational Level Consideration**: Personalizes based on user educational background.
- **Language Proficiency Adaptation**: Adapts difficulty to the user’s language skill level.

### 🔹 Analytics

- **Performance Tracking with EMA**: Tracks user performance through Exponential Moving Average (EMA).
- **Detailed Feedback System**: Offers specific feedback based on performance.
- **Progress Visualization**: Visual representation of user growth over time.
- **Learning Curve Analysis**: Breaks down learning trends and patterns.

---

## 🕹 Game Mechanics

### Categories

- **Fruits**, **Colors**, **Animals**, **Professions**, **Countries**, **Household Items**, **Body Parts**, **Vehicles**, **Emotions**

### Difficulty Levels

- **Range**: 3-10
- **Adaptive Scaling**: Difficulty adapts to each user.
- **Profile-Influenced Baseline**: Starts based on user profile information.
- **Performance-Based Adjustments**: Dynamic adjustment based on progress.

### Scoring System

The score calculation is based on:

```python
score = base_score * time_factor * difficulty_factor
```

**📖 Description**
NeuroCognix represents a sophisticated approach to cognitive training, blending cutting-edge technology with proven psychological principles. Our adaptive learning system creates a unique experience for every user, adjusting based on profile, performance, and cognitive state.

**Key Technical Implementations:**

- Exponential Moving Average (EMA) for response time tracking
- Levenshtein Distance Calculations for word similarity scoring
- Cognitive Load Monitoring & Management to prevent fatigue
- Dynamic Difficulty Adjustment Algorithms for seamless progression
- Comprehensive User Profiling System for personalized experiences
