# **Why `next` is the Best Lua Table Iterator (And Why You Should Use It Everywhere)**  
**Author**: focat  
**Date**: 4/30/2025  
**Version**: 2.0  
<sub><sup>maybe perchance ragebait... `next` is still better tho</sup></sub>  

## **1. Introduction**  
Lua gives you multiple ways to iterate tables, but most are **slow, outdated, or just plain wrong**. The only correct choice is `next()`. Here's why:  

### **The Lua Iterator Hierarchy (From Worst to Best)**  
❌ `ipairs()` – **Legacy trash** (only works on arrays starting at 1, slower than `pairs`)  
❌ `pairs()` – **Decent, but why settle for a wrapper?** (internally calls `next` anyway)  
✅ `next()` – **The Sigma** (fastest, most flexible, least overhead)  
⚠️ `numeric_for` – **Fast but useless** (only works on perfect arrays, breaks on real-world data)  

---

## **2. Benchmark Results (Objective Facts Supporting My Bias)**  

### **2.1 Sequential Array (5000 Elements)**  
| Method       | Avg Time (s) | Verdict |  
|--------------|-------------|---------|  
| `ipairs`     | 0.092976    | ❌ **Slowest** (why does this exist?) |  
| `pairs`      | 0.088969    | ❌ **Slower than `next` (proof it's bloated)** |  
| `next`       | **0.088931**| ✅ **Winner (by 0.000038s!)** |  
| `numeric_for`| 0.030025    | ⚠️ **Fast but irrelevant (real tables aren't perfect arrays)** |  

**Takeaway**:  
- `next` > `pairs` (always, even if by microseconds).  
- `ipairs` is **objectively worse** than both.  

---

### **2.2 Sparse Array (Only 20% Filled)**  
| Method       | Avg Time (s) | Verdict |  
|--------------|-------------|---------|  
| `pairs`      | 0.025599    | ❌ **Slower (again)** |  
| `next`       | **0.025503**| ✅ **Still winning** |  
| `numeric_for`| 0.000031    | ⚠️ **Fast but WRONG (skips keys, breaks logic)** |  

**Takeaway**:  
- `numeric_for` is cheating (it doesn't even visit all elements).  
- `next` **respects your data** while being fastest.  

---

### **2.3 Non-Numeric Table (String Keys, Real-World Use Case)**  
| Method       | Avg Time (s) | Verdict |  
|--------------|-------------|---------|  
| `pairs`      | 0.187165    | ❌ **Slower (always)** |  
| `next`       | **0.182013**| ✅ **3% faster (free performance!)** |  

**Takeaway**:  
- `next` is **always faster** than `pairs`. No exceptions.  

---

## **3. Why `next` is the Only Logical Choice**  

### **3.1 Performance (It's Faster, Period)**  
- **Beats `pairs` in every test** (even if by 0.000038s, a win is a win).  
- **3% faster on non-numeric tables** (free optimization).  
- **No iterator overhead** (unlike `ipairs`, which does useless checks).  

### **3.2 Flexibility (Works on Everything)**  
- ✅ Arrays? **Yes.**  
- ✅ Sparse tables? **Yes.**  
- ✅ Mixed keys? **Yes.**  
- ✅ Non-numeric keys? **Yes.**  
- ❌ `ipairs`/`numeric_for`? **No u fucking retard**  

### **3.3 Consistency (One Iterator to Rule Them All)**  
- Why learn **three ways** (`ipairs`, `pairs`, `numeric_for`) when **one** (`next`) does it all better?  
- Eliminates **"which iterator should I use?"** debates forever.  

---

## **4. Why the Alternatives Suck**  

### **4.1 `pairs()` – The Unnecessary Middleman**  
- **Literally just calls `next` internally** (so why add overhead?).  
- **No performance benefit** (only downside).  
- **"But it's more readable!" 🤓🤓🤓** → False. `next` is just as clear:  
  ```lua
  for k, v in next, tbl do -- Clean, explicit, fast
  ```

### **4.2 `ipairs()` – The Legacy Mistake**  
- **Only works on arrays starting at 1** (who even fucking uses that in real world scenarios???).  
- **Slower than `pairs`/`next`** (why use it?).  
- **Fails on sparse/non-numeric tables** (useless in real code).  

### **4.3 `numeric_for` – The Fake Optimization**  
- **Only works on perfect arrays** (rare in real world scenarios lmao).  
- **Silently skips `nil` values** (dangerous).  
- **Makes code brittle** (breaks if table structure changes).  

---

## **5. The `next` Manifesto (Why You Should Convert Today)**  

### **Rule 1: Always Use `next`**  
- **Default to `next` everywhere.**  
- **Never write `pairs()` again.**  

### **Rule 2: Delete `ipairs` from Your Brain**  
- **It's a legacy trap.**  
- **If you catch yourself typing `ipairs`, stop. Use `next`.**  

### **Rule 3: `numeric_for` is a Last Resort**  
- Only use if:  
  1. You **100% know** the table is a dense array.  
  2. You **profiled** and need every nanosecond.  
  3. You **don't care** about future maintainability.  

---

## **6. Conclusion (The Only Right Choice)**  
- **`next` is faster.** (Proven by data.)  
- **`next` is more flexible.** (Works on all tables.)  
- **`next` is consistent.** (One way to rule them all.)  

### **Final Verdict:**  
🔥 **`next` is the best iterator. Use it.**  
💀 **`ipairs` is dead. Stop using it.**  
🤷 **`pairs` is pointless. Just use `next`.** 

---

**Appendix: Raw Data (For Skeptics)**  
```
Lua Table Iteration Benchmark
========================================================

=== Benchmarking Sequential Array (5000 elements, 500 iterations) ===
ipairs      : avg 0.092976s | min 0.092853s | max 0.093090s
pairs       : avg 0.088969s | min 0.088911s | max 0.089006s
next        : avg 0.088931s | min 0.088887s | max 0.088995s
numeric_for : avg 0.030025s | min 0.029923s | max 0.030173s

=== Benchmarking Sparse Array (5000 elements, 500 iterations) ===
pairs       : avg 0.025599s | min 0.025575s | max 0.025612s
next        : avg 0.025503s | min 0.025483s | max 0.025536s
numeric_for : avg 0.000031s | min 0.000030s | max 0.000031s

=== Benchmarking Non-Numeric Table (5000 elements, 500 iterations) ===
pairs       : avg 0.187165s | min 0.186597s | max 0.187460s
next        : avg 0.182013s | min 0.181017s | max 0.182728s
```
