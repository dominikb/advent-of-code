(ns solution)

(require '[clojure.string :as str])
(require '[babashka.deps :as deps])

(deps/add-deps '{:deps
                 {org.clojure/math.combinatorics
                  {:mvn/version "0.2.0"}}})

(require '[clojure.math.combinatorics :as combo])

(def input (slurp "/Users/dob/code/advent-of-code/2023/day07/input.txt"))

(def example
  "32T3K 765
   T55J5 684
   KK677 28
   KTJJT 220
   QQQJA 483")

(def cards "AKQT98765432J")
(def types (list :five_of_a_kind :four_of_a_kind :full_house :three_of_a_kind, :two_pairs, :one_pair, :high_card))

(defn position [item list]
  (loop [item item
         [head & tail] list
         idx 0]
    (cond
      (= item head) idx
      (empty? tail) nil
      :else (recur item tail (inc idx)))))

(defn type-of-hand [cards]
  (let [freq (->> cards frequencies vals sort)]
    (condp = freq
      '(5) :five_of_a_kind
      '(1 4) :four_of_a_kind
      '(2 3) :full_house
      '(1 1 3) :three_of_a_kind
      '(1 2 2) :two_pairs
      '(1 1 1 2) :one_pair
      :high_card)))

(defn cards-comparator
  ([] 0)
  ([[a & a_tail], [b & b_tail]]
   (cond
     (= a b) (cards-comparator a_tail b_tail)
     :else (- (str/index-of cards a) (str/index-of cards b)))))

(defn hands-comparator
  ([] 0)
  ([a, b]
  ;;  (let [a_type (type-of-hand-with-joker a),
  ;;        b_type (type-of-hand-with-joker b)]
   (let [a_type (type-of-hand a),
         b_type (type-of-hand b)]
     (cond
       (= a_type b_type) (cards-comparator a b)
       :else (- (position a_type types) (position b_type types))))))

(defn type-of-hand-with-joker
  "Highest type  "
  ([hand] (let [hand-without-joker (remove #{\J} hand),
                distinct-cards (distinct hand-without-joker),
                n (- 5 (count hand-without-joker)),
                possible-replacements (combo/selections distinct-cards n),
                possible-hands (map #(concat hand-without-joker %) possible-replacements)]
            (if (empty? distinct-cards)
              :five_of_a_kind
              (->> possible-hands
                   (sort hands-comparator)
                   first
                   type-of-hand)))))

(defn parse [input]
  (let [lines (str/split-lines input)]
    (->> lines
         (map str/trim)
         (map #(str/split % #" ")))))

(defn part1 [input]
  (->> input
       (parse)
       (sort-by first hands-comparator)
       reverse
       (map #(. Integer parseInt (second %)))
       (map-indexed (fn [idx bid] (* (inc idx) bid)))
       (reduce +)))

(defn part2 [input] (part1 input))


(println "Part 1")
(println (list "Example" (part1 example)))
(println (list "Input" (part1 input)))

(defn hands-comparator
  ([] 0)
  ([a, b]
   (let [a_type (type-of-hand-with-joker a),
         b_type (type-of-hand-with-joker b)]
  ;;  (let [a_type (type-of-hand a),
  ;;        b_type (type-of-hand b)]
     (cond
       (= a_type b_type) (cards-comparator a b)
       :else (- (position a_type types) (position b_type types))))))

(defn type-of-hand-with-joker
  "Highest type  "
  ([hand] (let [hand-without-joker (remove #{\J} hand),
                distinct-cards (distinct hand-without-joker),
                n (- 5 (count hand-without-joker)),
                possible-replacements (combo/selections distinct-cards n),
                possible-hands (map #(concat hand-without-joker %) possible-replacements)]
            (if (empty? distinct-cards)
              :five_of_a_kind
              (->> possible-hands
                   (sort hands-comparator)
                   first
                   type-of-hand)))))

(println "Part 2")
(println (list "Example" (part2 example)))
(println (list "Input" (part2 input)))