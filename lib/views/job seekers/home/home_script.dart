import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

// --- AGGREGATOR SCRIPT ---

// -- CODE FOR FETCHING JOBSTREET JOB POSTS --
Future<String> fetchJobStreetData() async {
  const url = 'https://corsproxy.io/?https://www.jobstreet.com.ph/jobs';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('jobstreet success fetching ${response.statusCode}');
    return response.body;
  } else {
    throw Exception('Failed to load jobstreet page');
  }
}

List<Map<String, String>> parseJobStreetData(String htmlContent) {
  var document = parse(htmlContent);
  List<Map<String, String>> jobs = [];

  document
      .querySelectorAll('article[data-testid="job-card"]')
      .take(5)
      .forEach((element) {
    String? postedDate =
        element.querySelector('span[data-automation="jobListingDate"]')?.text;
    String? title =
        element.querySelector('a[data-automation="jobTitle"]')?.text;
    String? location =
        element.querySelector('span[data-automation="jobCardLocation"]')?.text;
    // String? description = element
    //     .querySelector('span[data-automation="jobShortDescription"]')
    //     ?.text;
    String? salary =
        element.querySelector('span[data-automation="jobSalary"]')?.text;
    String? jobLink = element
        .querySelector('a[data-automation="job-list-item-link-overlay"]')
        ?.attributes['href'];

    if (title != null && location != null && jobLink != null) {
      jobs.add({
        'datePosted': postedDate ?? 'Unknown date',
        'title': title,
        'location': location,
        // 'description': description ?? 'No description available',
        'salary': salary ?? 'Salary not provided',
        'jobLink': 'https://www.jobstreet.com.ph${jobLink}',
        'website': 'JobStreet'
      });
    }
  });
  return jobs;
}
// -- jobstreet END --

// -- LINKIND --
Future<String> fetchLinkedInData() async {
  const url =
      'https://corsproxy.io/?https://www.linkedin.com/jobs/jobs-in-philippines';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('linkedin success fetching ${response.statusCode}');
    return response.body;
  } else {
    throw Exception('Failed to load linkedin page');
  }
}

List<Map<String, String>> parseLinkedInData(String htmlContent) {
  var document = parse(htmlContent);
  List<Map<String, String>> jobs = [];

  document.querySelectorAll('.base-card').take(5).forEach((element) {
    String? title =
        element.querySelector('h3.base-search-card__title')?.text.trim();
    String? location =
        element.querySelector('span.job-search-card__location')?.text.trim();
    String? postedDate =
        element.querySelector('time.job-search-card__listdate')?.text.trim();
    String? jobLink =
        element.querySelector('a.base-card__full-link')?.attributes['href'];

    if (title != null && jobLink != null) {
      jobs.add({
        'title': title,
        'location': location ?? 'Location not provided',
        'datePosted': postedDate ?? 'Unknown date',
        'jobLink': jobLink.startsWith('http')
            ? jobLink
            : 'https://ph.linkedin.com${jobLink}',
        'website': 'LinkedIn'
      });
    }
  });
  return jobs;
}
// -- END LINKEND --

// -- onlinejobsph --

Future<String> fetchOnlineJobsData() async {
  const url =
      'https://corsproxy.io/?https://www.onlinejobs.ph/jobseekers/jobsearch';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('onlinejobs success fetching ${response.statusCode}');
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
        'jobLink': 'https://www.onlinejobs.ph${jobLink}',
        'website': 'OnlineJobs'
      });
    }
  });
  return jobs;
}
// -- end--

Future<String> fetchKalibrrData() async {
  const url =
      'https://corsproxy.io/?https://www.kalibrr.com/home/co/Philippines';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('kalibrr success fetching ${response.statusCode}');
    return response.body;
  } else {
    throw Exception('Failed to load kalibrr page');
  }
}

List<Map<String, String>> parseKalibrrData(String htmlContent) {
  var document = parse(htmlContent);
  List<Map<String, String>> jobs = [];

  document
      .querySelectorAll('div.k-font-dm-sans.k-rounded-lg')
      .take(5)
      .forEach((element) {
    String? title = element.querySelector('h2 a[itemprop="name"]')?.text;
    String? location = element.querySelector('span.k-text-gray-500')?.text;
    // String? postedDate = element.querySelector('span.k-text-gray-500')?.text;
    String? postedDate;
    var spans = element.querySelectorAll('span.k-flex.k-gap-4.k-text-gray-300');

    for (var span in spans) {
      var text = span.querySelector('span.k-text-gray-500')?.text.trim();
      if (text != null && text.startsWith('Recruiter was hiring')) {
        postedDate = text.replaceFirst('Recruiter was hiring', '').trim();
        if (postedDate.isNotEmpty) {
          postedDate = postedDate[0].toUpperCase() + postedDate.substring(1);
        }
        break;
      }
    }
    String? jobLink =
        element.querySelector('h2 a[itemprop="name"]')?.attributes['href'];

    if (title != null && location != null && jobLink != null) {
      jobs.add({
        'title': title,
        'location': location,
        'datePosted': postedDate ?? 'No date posted',
        'jobLink': 'https://www.kalibrr.com/${jobLink}',
        'website': 'Kalibrr'
      });
    }
  });

  return jobs;
}

// -- CODE FOR FETCHING PHILJOBNET JOB POSTS --
Future<String> fetchPhilJobNetData() async {
  const url = 'https://corsproxy.io/?https://philjobnet.gov.ph/job-vacancies/';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('PhilJobNet success fetching ${response.statusCode}');
    return response.body;
  } else {
    throw Exception('Failed to load PhilJobNet page');
  }
}

List<Map<String, String>> parsePhilJobNetData(String htmlContent) {
  var document = parse(htmlContent);
  List<Map<String, String>> jobs = [];

  document.querySelectorAll('tr').take(5).forEach((element) {
    String? jobTitle = element.querySelector('h1.jobtitle')?.text.trim();
    String? salary = element.querySelector('h3.salary')?.text.trim();
    String? location = element.querySelector('div.col-lg-5')?.text.trim();
    String? postedDate = element.querySelector('span.jobinfo')?.text.trim();
    String? jobLink =
        element.querySelector('a.nolink')?.attributes['href']?.trim();

    if (jobLink != null && jobLink.startsWith('/')) {
      jobLink = 'https://philjobnet.gov.ph$jobLink';
    }

    if (jobTitle != null && jobLink != null) {
      jobs.add({
        'title': jobTitle,
        'salary': salary ?? 'Salary not provided',
        'location': location ?? 'Location not provided',
        'datePosted': postedDate ?? 'Unknown date',
        'jobLink': jobLink,
        'website': 'PhilJobNet'
      });
    }
  });

  return jobs;
}

//  function to fetch job descriptions
Future<String?> fetchJobDescription(String jobUrl, String source) async {
  String url = "https://corsproxy.io/?${jobUrl}";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var document = parse(response.body);
      String? jobDescription;

      if (source == 'philJobNet') {
        jobDescription =
            document.querySelector('div.jobdescription')?.text.trim();
      } else if (source == 'jobStreet') {
        var jobDetailsDiv = document.querySelector('div._1vpsrtt0._4pyceb0');
        if (jobDetailsDiv != null) {
          var children = jobDetailsDiv.children.take(2);
          jobDescription = children
              .map((child) => child.text.trim())
              .where((text) => text.isNotEmpty)
              .join('\n\n')
              .trim();
        }
      }
      return jobDescription ?? 'No description available';
    } else {
      throw Exception('Failed to load job details page');
    }
  } catch (e) {
    print('Error fetching job description: $e');
    return 'No description available';
  }
}

//  function to fetch jobs with descriptions
Future<List<Map<String, String>>> fetchJobsWithDescriptions(
    String source) async {
  List<Map<String, String>> jobs;

  if (source == 'philJobNet') {
    String htmlContent = await fetchPhilJobNetData();
    jobs = parsePhilJobNetData(htmlContent);
  } else if (source == 'jobStreet') {
    String htmlContent = await fetchJobStreetData();
    jobs = parseJobStreetData(htmlContent);
  } else {
    throw Exception('Unknown source');
  }

  for (var job in jobs) {
    String? jobLink = job['jobLink'];
    if (jobLink != null) {
      String? description = await fetchJobDescription(jobLink, source);
      job['description'] = description!;
    }
  }

  return jobs;
}
