# Paths to the files you want to open
file_path1 = 'questions'
file_path2 = 'explanations'
file_path3 = 'questionnaire.json'
with open(file_path3, 'w') as file:
    file.write("[\n")

q_count  = 1
q_threshold = [30,54,71,83]
with open(file_path1, 'r') as file1, open(file_path2, 'r') as file2, open(file_path3, 'a') as file3:
    for line1, line2 in zip(file1, file2):
        section = 0
        for th in q_threshold:
            if q_count>th:
                section+=1
        file3.write('\t{\n')
        file3.write('\t\t\"text\": "'+line1[:-1]+'",\n')
        file3.write('\t\t\"explanation\": "'+line2[:-1]+'",\n')
        file3.write('\t\t\"section\": '+str(section)+'\n')
        file3.write('\t},\n')
    

with open(file_path3, 'a') as file:
    file.write("]")
