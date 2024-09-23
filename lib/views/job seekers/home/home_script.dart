import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

// --- AGGREGATOR SCRIPT ---
  
// -- CODE FOR FETCHING JOBSTREET JOB POSTS --
  Future<String> fetchJobStreetData() async {
    const url = 'https://corsproxy.io/?https://www.jobstreet.com.ph/jobs';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load jobstreet page');
    }
  }

  List<Map<String, String>> parseJobStreetData(String htmlContent) {
    var document = parse(htmlContent);
    List<Map<String, String>> jobs = [];
    
    document.querySelectorAll('article[data-testid="job-card"]').take(5).forEach((element) {
      String? postedDate = element.querySelector('span[data-automation="jobListingDate"]')?.text;
      String? title = element.querySelector('a[data-automation="jobTitle"]')?.text;
      String? location = element.querySelector('span[data-automation="jobCardLocation"]')?.text;
      String? description = element.querySelector('span[data-automation="jobShortDescription"]')?.text;
      String? salary = element.querySelector('span[data-automation="jobSalary"]')?.text;
      String? jobLink = element.querySelector('a[data-automation="job-list-item-link-overlay"]')?.attributes['href'];

      if (title != null && location != null && jobLink != null) {
        jobs.add({
          'datePosted': postedDate ?? 'Unknown date',
          'title': title,
          'location': location,
          'description': description ?? 'No description available',
          'salary': salary ?? 'Salary not provided',
          'jobLink': 'https://www.jobstreet.com.ph${jobLink}'
        });
      }
    });
    return jobs;
  }
// -- jobstreet END --

// -- CODE FOR FETCHING UPWORK JOB POSTS --
 Future<String> fetchUpworkData() async {
    const url = 'https://www.upwork.com/freelance-jobs/filipino/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load page');
    }
  }

  List<Map<String, String>> parseUpworkData(String htmlContent) {
    var document = parse(htmlContent);
    List<Map<String, String>> jobs = [];

    document.querySelectorAll('div.job-tile-wrapper').take(10).forEach((element) { // KAHIT 10 ILAGAY SA TAKE e 5 parin na fefetch niya haha
      String? title = element.querySelector('a[data-qa="job-title"]')?.text.trim();
      String? description = element.querySelector('p[data-qa="job-description"]')?.text.trim();
      
      List<String> tags = element.querySelectorAll('div.skills-list span').map((e) => e.text.trim()).toList();

      String? jobLink = element.querySelector('a[data-qa="job-title"]')?.attributes['href']?.trim();
      if (jobLink != null && jobLink.startsWith('/')) {
        // Prepend the base URL if needed
        jobLink = 'https://www.upwork.com$jobLink';
      }
      
      // ayaw ma fetch netong date and rate
      // String? postedDate = element.querySelectorAll('small.text-muted-on-inverse').last.text.trim(); 
      // String? rate = element.querySelector('p span strong')?.text.trim(); 

      if (title != null) {
        jobs.add({
          'title': title,
          // 'postedDate': postedDate.isEmpty ? 'Unknown date' : postedDate,
          // 'rate': rate?.isEmpty ?? true ? 'Not specified' : rate!,
          'description': description!.isEmpty ? 'No description available' : description,
          'tags': tags.isEmpty ? 'No skills specified' : tags.join(', '),
          'jobLink': jobLink ?? ''
        });
      }
    });

    return jobs;
  }
// -- end Upwork -- 

// -- CODE FOR FETCHING INDEED JOB POSTS --
  Future<String> fetchIndeedData() async {
    const url = 'https://ph.indeed.com/q-indeed-philippines-jobs.html';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load Indeed page');
    }
  }
  
  List<Map<String, String>> parseIndeedData(String htmlContent) {
    var document = parse(htmlContent);
    List<Map<String, String>> jobs = [];

    document.querySelectorAll('div.cardOutline').take(5).forEach((element) {
      // String? postedDate = element.querySelector('span[data-testid="myJobsStateDate"]')?.text;
      // String? fullDateText = element.querySelector('span[data-testid="myJobsStateDate"]')?.text;
      // String? postedDate = fullDateText?.split('Active ')[1];
      String? postedDate = element.querySelector('span[data-testid="myJobsStateDate"]')?.text;
      if (postedDate != null) {
        postedDate = RegExp(r'\d+ days ago').firstMatch(postedDate)?.group(0);
      }
      String? title = element.querySelector('h2.jobTitle span')?.text;
      String? location = element.querySelector('div[data-testid="text-location"]')?.text;
      String? salary = element.querySelector('div.metadata.salary-snippet-container')?.text;
      // String? description = "";
      String? jobLink = element.querySelector('a.jcs-JobTitle')?.attributes['href'];

      if (title != null && location != null && jobLink != null) {
        jobs.add({
          'datePosted': postedDate ?? 'Unknown date',
          'title': title,
          'location': location,
          'salary': salary ?? 'Salary not provided',
          // 'description': description ?? 'No description available',
          'jobLink': 'https://ph.indeed.com${jobLink}'
        });
      }
    });

    return jobs;
  }
// -- indeed END --

// -- LINKIND --
    Future<String> fetchLinkedInData() async {
    const url = 'https://corsproxy.io/?https://www.linkedin.com/jobs/jobs-in-philippines';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load linkedin page');
    }
  }

  List<Map<String, String>> parseLinkedInData(String htmlContent) {
    var document = parse(htmlContent);
    List<Map<String, String>> jobs = [];
    
    document.querySelectorAll('.base-card').take(5).forEach((element) {
      String? title = element.querySelector('h3.base-search-card__title')?.text.trim();
      String? location = element.querySelector('span.job-search-card__location')?.text.trim();
      String? postedDate = element.querySelector('time.job-search-card__listdate')?.text.trim();
      String? jobLink = element.querySelector('a.base-card__full-link')?.attributes['href'];
      
      if (title != null && jobLink != null) {
        jobs.add({
          'title': title,
          'location': location ?? 'Location not provided',
          'datePosted': postedDate ?? 'Unknown date',
          'jobLink': jobLink.startsWith('http') ? jobLink : 'https://ph.linkedin.com${jobLink}'
        });
      }
    });
    return jobs;
  }
// -- END LINKEND --

// -- onlinejobsph --

 Future<String> fetchOnlineJobsData() async {
    const url = 'https://corsproxy.io/?https://www.onlinejobs.ph/jobseekers/jobsearch';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load onlinejobsph page');
    }
  }

List<Map<String, String>> parseOnlineJobsData(String htmlContent) {
  var document = parse(htmlContent);
  List<Map<String, String>> jobs = [];
  
  document.querySelectorAll('.jobpost-cat-box').take(5).forEach((element) {
    String? title = element.querySelector('h4.fs-16')?.text.trim();
    String? postedDate = element.querySelector('p.fs-13 em')?.text.trim();
    String? description = element.querySelector('div.desc')?.text.trim();
    String? salary = element.querySelector('dl.row.fs-14 dd')?.text.trim();
    String? jobLink = element.querySelector('a')?.attributes['href'];
    
    if (title != null && jobLink != null) {
      jobs.add({
        'datePosted': postedDate ?? 'Unknown date',
        'title': title,
        'description': description ?? 'No description available',
        'salary': salary ?? 'Salary not provided',
        'jobLink': 'https://www.onlinejobs.ph${jobLink}'
      });
    }
  });
  return jobs;
}
// -- end--