# kung hindi mag work, first do this in terminal: pip install Flask requests beautifulsoup4
# then run this py code

from flask import Flask, jsonify
import requests
from bs4 import BeautifulSoup

app = Flask(__name__)

def fetch_html(url):
    try:
        response = requests.get(url)
        if response.status_code == 200:
            return response.text
        else:
            print(f"Failed to retrieve {url} with status code {response.status_code}")
            return None
    except Exception as e:
        print(f"Error fetching {url}: {e}")
        return None

# --- JOBSTREET ---
@app.route('/scrape/jobstreet', methods=['GET'])
def scrape_jobstreet():
    url = 'https://www.jobstreet.com.ph/jobs'
    html_content = fetch_html(url)
    if not html_content:
        return jsonify({"error": "Failed to fetch JobStreet data"}), 500
    
    soup = BeautifulSoup(html_content, 'html.parser')
    jobs = []
    
    for element in soup.select('article[data-testid="job-card"]')[:5]:
        posted_date = element.select_one('span[data-automation="jobListingDate"]').text if element.select_one('span[data-automation="jobListingDate"]') else 'Unknown date'
        title = element.select_one('a[data-automation="jobTitle"]').text if element.select_one('a[data-automation="jobTitle"]') else 'No title'
        location = element.select_one('span[data-automation="jobCardLocation"]').text if element.select_one('span[data-automation="jobCardLocation"]') else 'No location'
        description = element.select_one('span[data-automation="jobShortDescription"]').text if element.select_one('span[data-automation="jobShortDescription"]') else 'No description'
        salary = element.select_one('span[data-automation="jobSalary"]').text if element.select_one('span[data-automation="jobSalary"]') else 'Salary not provided'
        job_link = 'https://www.jobstreet.com.ph' + element.select_one('a[data-automation="job-list-item-link-overlay"]')['href'] if element.select_one('a[data-automation="job-list-item-link-overlay"]') else '#'
        
        jobs.append({
            'datePosted': posted_date,
            'title': title,
            'location': location,
            'description': description,
            'salary': salary,
            'jobLink': job_link
        })
    
    return jsonify(jobs)

# --- UPWORK ---  ERROR 403 ITO FORBIDDEN
# @app.route('/scrape/upwork', methods=['GET'])
# def scrape_upwork():
#     url = 'https://www.upwork.com/freelance-jobs/filipino/'
#     html_content = fetch_html(url)
#     if not html_content:
#         return jsonify({"error": "Failed to fetch Upwork data"}), 500
    
#     soup = BeautifulSoup(html_content, 'html.parser')
#     jobs = []
    
#     for element in soup.select('div.job-tile-wrapper')[:5]:
#         title = element.select_one('a[data-qa="job-title"]').text.strip() if element.select_one('a[data-qa="job-title"]') else 'No title'
#         description = element.select_one('p[data-qa="job-description"]').text.strip() if element.select_one('p[data-qa="job-description"]') else 'No description'
#         tags = ', '.join([tag.text.strip() for tag in element.select('div.skills-list span')])
#         job_link = 'https://www.upwork.com' + element.select_one('a[data-qa="job-title"]')['href'] if element.select_one('a[data-qa="job-title"]') else '#'
        
#         jobs.append({
#             'title': title,
#             'description': description,
#             'tags': tags,
#             'jobLink': job_link
#         })
    
#     return jsonify(jobs)

# # --- INDEED --- ERROR 403 ITO FORBIDDEN
# @app.route('/scrape/indeed', methods=['GET'])
# def scrape_indeed():
#     url = 'https://ph.indeed.com/q-indeed-philippines-jobs.html'
#     html_content = fetch_html(url)
#     if not html_content:
#         return jsonify({"error": "Failed to fetch Indeed data"}), 500
    
#     soup = BeautifulSoup(html_content, 'html.parser')
#     jobs = []
    
#     for element in soup.select('div.cardOutline')[:5]:
#         posted_date = element.select_one('span[data-testid="myJobsStateDate"]').text if element.select_one('span[data-testid="myJobsStateDate"]') else 'Unknown date'
#         title = element.select_one('h2.jobTitle span').text if element.select_one('h2.jobTitle span') else 'No title'
#         location = element.select_one('div[data-testid="text-location"]').text if element.select_one('div[data-testid="text-location"]') else 'No location'
#         salary = element.select_one('div.metadata.salary-snippet-container').text if element.select_one('div.metadata.salary-snippet-container') else 'Salary not provided'
#         job_link = 'https://ph.indeed.com' + element.select_one('a.jcs-JobTitle')['href'] if element.select_one('a.jcs-JobTitle') else '#'
        
#         jobs.append({
#             'datePosted': posted_date,
#             'title': title,
#             'location': location,
#             'salary': salary,
#             'jobLink': job_link
#         })
    
#     return jsonify(jobs)

# --- LINKEDIN ---
@app.route('/scrape/linkedin', methods=['GET'])
def scrape_linkedin():
    url = 'https://www.linkedin.com/jobs/jobs-in-philippines'
    html_content = fetch_html(url)
    if not html_content:
        return jsonify({"error": "Failed to fetch LinkedIn data"}), 500
    
    soup = BeautifulSoup(html_content, 'html.parser')
    jobs = []
    
    for element in soup.select('.base-card')[:5]:
        title = element.select_one('h3.base-search-card__title').text.strip() if element.select_one('h3.base-search-card__title') else 'No title'
        location = element.select_one('span.job-search-card__location').text.strip() if element.select_one('span.job-search-card__location') else 'No location'
        posted_date = element.select_one('time.job-search-card__listdate').text.strip() if element.select_one('time.job-search-card__listdate') else 'Unknown date'
        job_link = element.select_one('a.base-card__full-link')['href'] if element.select_one('a.base-card__full-link') else '#'
        
        jobs.append({
            'title': title,
            'location': location,
            'datePosted': posted_date,
            'jobLink': job_link
        })
    
    return jsonify(jobs)

# --- ONLINEJOBS.PH ---
@app.route('/scrape/onlinejobs', methods=['GET'])
def scrape_onlinejobs():
    url = 'https://www.onlinejobs.ph/jobseekers/jobsearch'
    html_content = fetch_html(url)
    if not html_content:
        return jsonify({"error": "Failed to fetch OnlineJobs.ph data"}), 500
    
    soup = BeautifulSoup(html_content, 'html.parser')
    jobs = []
    
    for element in soup.select('.jobpost-cat-box')[:5]:
        title = element.select_one('h4.fs-16').text.strip() if element.select_one('h4.fs-16') else 'No title'
        posted_date = element.select_one('p.fs-13 em').text.strip() if element.select_one('p.fs-13 em') else 'Unknown date'
        description = element.select_one('div.desc').text.strip() if element.select_one('div.desc') else 'No description'
        salary = element.select_one('dl.row.fs-14 dd').text.strip() if element.select_one('dl.row.fs-14 dd') else 'Salary not provided'
        job_link = 'https://www.onlinejobs.ph' + element.select_one('a')['href'] if element.select_one('a') else '#'
        
        jobs.append({
            'datePosted': posted_date,
            'title': title,
            'description': description,
            'salary': salary,
            'jobLink': job_link
        })
    
    return jsonify(jobs)

if __name__ == '__main__':
    app.run(debug=True)
