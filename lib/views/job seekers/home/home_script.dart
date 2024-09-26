import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

Future<String> fetchJobStreetData(String searchQuery) async {
  String url = 'https://corsproxy.io/?https://www.jobstreet.com.ph/jobs';
  if (searchQuery.isNotEmpty) {
    url =
        'https://corsproxy.io/?https://www.jobstreet.com.ph/$searchQuery-jobs';
  }
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('Jobstreet success fetching ${response.statusCode}');
    return response.body;
  } else {
    print('Jobstreet fetch failed with status: ${response.statusCode}');
    throw Exception('Failed to load JobStreet page');
  }
}

List<Map<String, String>> parseJobStreetData(String htmlContent) {
  var document = html.parse(htmlContent);
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
    String? salary =
        element.querySelector('span[data-automation="jobSalary"]')?.text;
    String? jobLink = element
        .querySelector('a[data-automation="job-list-item-link-overlay"]')
        ?.attributes['href'];
    // for tags
    String? subClassification = element
        .querySelector('a[data-automation="jobSubClassification"]')
        ?.text;
    String? classification = element
        .querySelector('a[data-automation="jobClassification"]')
        ?.text
        ?.replaceAll('(', '')
        .replaceAll(')', '');

    List<String> tags = [];
    if (subClassification != null) {
      tags.add(subClassification);
    }
    if (classification != null) {
      tags.add(classification);
    }

    if (title != null && location != null && jobLink != null) {
      jobs.add({
        'datePosted': postedDate ?? 'Unknown date',
        'title': title,
        // 'description': '', // Placeholder for job description
        'location': location,
        'tags': tags.join(', '),
        'salary': salary ?? 'Salary not provided',
        'jobLink': 'https://www.jobstreet.com.ph${jobLink}',
        'proxyLink':
            'https://corsproxy.io/?https://www.jobstreet.com.ph${jobLink}',
        'website': 'JOBSTREET'
      });
    }
  });

  return jobs;
}

Future<String> fetchLinkedInData(String searchQuery) async {
  await Future.delayed(Duration(
      // comment this
      seconds:
          5)); // Delay between requests to prevent error 429, too many requests

  String url =
      'https://corsproxy.io/?https://www.linkedin.com/jobs/jobs-in-philippines';
  if (searchQuery.isNotEmpty) {
    url =
        'https://corsproxy.io/?https://www.linkedin.com/jobs/search?keywords=$searchQuery&location=Philippines&geoId=103121230&trk=public_jobs_jobs-search-bar_search-submit&original_referer=https%3A%2F%2Fwww.linkedin.com%2Fjobs%2Fjobs-in-philippines%3Fposition%3D1%26pageNum%3D0&position=1&pageNum=0';
  }
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    print('LinkedIn fetch failed with status: ${response.statusCode}');
    throw Exception('Failed to load LinkedIn page');
  }
}

List<Map<String, String>> parseLinkedInData(String htmlContent) {
  var document = html.parse(htmlContent);
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
        // 'tags': 'No Tag',
        'proxyLink': 'https://corsproxy.io/?${jobLink}',
        'website': 'LINKEDIN'
      });
    }
  });
  return jobs;
}

Future<String> fetchOnlineJobsData(String searchQuery) async {
  String url =
      'https://corsproxy.io/?https://www.onlinejobs.ph/jobseekers/jobsearch';
  if (searchQuery.isNotEmpty) {
    url =
        'https://corsproxy.io/?https://www.onlinejobs.ph/jobseekers/jobsearch?jobkeyword=$searchQuery&skill_tags=&gig=on&partTime=on&fullTime=on&isFromJobsearchForm=1';
  }
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('onlinejobs success fetching ${response.statusCode}');
    return response.body;
  } else {
    print('Onlinejobsph fetch failed with status: ${response.statusCode}');
    throw Exception('Failed to load onlinejobsph page');
  }
}

List<Map<String, String>> parseOnlineJobsData(String htmlContent) {
  var document = html.parse(htmlContent);
  List<Map<String, String>> jobs = [];

  document.querySelectorAll('.jobpost-cat-box').take(5).forEach((element) {
    String? title = element.querySelector('h4.fs-16')?.text.trim();
    String? postedDate = element.querySelector('p.fs-13 em')?.text.trim();
    String? description = element.querySelector('div.desc')?.text.trim();
    String? salary = element.querySelector('dl.row.fs-14 dd')?.text.trim();
    String? jobLink = element.querySelector('a')?.attributes['href'];
    List<String> tags = [];
    element.querySelectorAll('div[class="job-tag"] a').forEach((tagElement) {
      String? tag = tagElement.text;
      // print(tag);
      if (tag.isEmpty) {
        tags.remove(tag);
      } else {
        tags.add(tag);
      }
    });

    if (title != null && jobLink != null) {
      jobs.add({
        'datePosted': postedDate ?? 'Unknown date',
        'title': title,
        'description': description ?? 'No description available',
        'salary': salary ?? 'Salary not provided',
        'jobLink': 'https://www.onlinejobs.ph${jobLink}',
        // 'website': 'OnlineJobs',
        if (tags.isNotEmpty) 'tags': tags.join(', '),
        'website': 'ONLINEJOBS'
      });
    }
  });
  return jobs;
}

Future<String> fetchKalibrrData(String searchQuery) async {
  String url =
      'https://corsproxy.io/?https://www.kalibrr.com/home/co/Philippines';
  if (searchQuery.isNotEmpty) {
    url =
        'https://corsproxy.io/?https://www.kalibrr.com/home/co/Philippines/te/$searchQuery';
  }
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('kalibrr success fetching ${response.statusCode}');
    return response.body;
  } else {
    throw Exception('Failed to load kalibrr page');
  }
}

List<Map<String, String>> parseKalibrrData(String htmlContent) {
  var document = html.parse(htmlContent);
  List<Map<String, String>> jobs = [];

  // Check for "No results" message before processing jobs
  var noResultsElement = document
      .querySelector('span.k-flex.k-gap-1.k-text-grey-600 > p.k-font-bold');
  if (noResultsElement != null &&
      noResultsElement.text.trim() == "No results") {
    print('No jobs found for the search query');
    return jobs; // Return empty jobs list if "No results" is found
  }

  document
      .querySelectorAll('div.k-font-dm-sans.k-rounded-lg')
      .take(5)
      .forEach((element) {
    String? title = element.querySelector('h2 a[itemprop="name"]')?.text;
    String? location = element.querySelector('span.k-text-gray-500')?.text;
    String? postedDate;
    var spans = element.querySelectorAll('span.k-flex.k-gap-4.k-text-gray-300');

    for (var span in spans) {
      var text = span.querySelector('span.k-text-gray-500')?.text.trim();
      if (text != null && text.startsWith('Recruiter was hiring')) {
        postedDate = text.replaceFirst('Recruiter was hiring', '').trim();
        if (postedDate!.isNotEmpty) {
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
        'jobLink': 'https://www.kalibrr.com${jobLink}',
        'proxyLink': 'https://corsproxy.io/?https://www.kalibrr.com${jobLink}',
        'website': 'KALIBRR',
      });
    }
  });

  return jobs;
}

Future<String> fetchPhilJobNetData() async {
  String url = 'https://corsproxy.io/?https://philjobnet.gov.ph/job-vacancies/';
  // WALA NAMAng link for job search dito

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print('PhilJobNet success fetching ${response.statusCode}');
    return response.body;
  } else {
    throw Exception('Failed to load PhilJobNet page');
  }
}

List<Map<String, String>> parsePhilJobNetData(String htmlContent) {
  var document = html.parse(htmlContent);
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
        'proxyLink': 'https://corsproxy.io/?$jobLink',
        'website': 'PhilJobNet',
        // 'tags': 'No Tag'
      });
    }
  });

  return jobs;
}

// OTHER INFO FETCHED HERE/for fetching of job desc and tags
Future<void> fetchJobStreetJobDesc(
    List<Map<String, String>> jobstreetJobs) async {
  for (var job in jobstreetJobs) {
    try {
      String jobDescription =
          await parseJobStreetDescription(job['proxyLink']!);
      job['description'] =
          jobDescription; // Store the description in the job map
    } catch (e) {
      print('Error fetching JobStreet description for ${job['title']}: $e');
      job['description'] =
          'Error fetching description'; // Optionally set an error message
    }
  }
}

Future<String> parseJobStreetDescription(String jobUrl) async {
  final response = await http.get(Uri.parse(jobUrl));
  if (response.statusCode == 200) {
    var document = html.parse(response.body);
    return document
            .querySelector('div[data-automation="jobAdDetails"]')
            ?.text ??
        'No description available';
  } else {
    return 'Error fetching description';
  }
}

Future<void> fetchPhilJobNetJobDesc(
    List<Map<String, String>> jobstreetJobs) async {
  for (var job in jobstreetJobs) {
    try {
      String jobDescription =
          await parsePhilJobNetDescription(job['proxyLink']!);
      job['description'] =
          jobDescription; // Store the description in the job map
    } catch (e) {
      print('Error fetching JobStreet description for ${job['title']}: $e');
      job['description'] =
          'Error fetching description'; // Optionally set an error message
    }
  }
}

Future<String> parsePhilJobNetDescription(String jobUrl) async {
  final response = await http.get(Uri.parse(jobUrl));
  if (response.statusCode == 200) {
    var document = html.parse(response.body);
    var jobDescription =
        document.querySelector('div.jobdescription')?.text.trim();
    if (jobDescription != null) {
      List<String> words = jobDescription.split(' ');
      jobDescription = words.take(55).join(' ');
    }
    return jobDescription ?? 'No description available';
  } else {
    return 'Error fetching description';
  }
}

Future<void> fetchKalibrrJobDesc(List<Map<String, String>> kalibrrJobs) async {
  for (var job in kalibrrJobs) {
    try {
      String jobDescription = await parseKalibrrDescription(job['proxyLink']!);
      job['description'] =
          jobDescription; // Store the description in the job map
    } catch (e) {
      print('Error fetching Kalibrr description for ${job['title']}: $e');
      job['description'] =
          'Error fetching description'; // Optionally set an error message
    }
  }
}

Future<String> parseKalibrrDescription(String jobUrl) async {
  final response = await http.get(Uri.parse(jobUrl));
  if (response.statusCode == 200) {
    var document = html.parse(response.body);
    var jobDescription =
        document.querySelector('div[itemprop="description"]')?.text.trim();

    if (jobDescription != null) {
      List<String> words = jobDescription.split(' ');
      jobDescription = words.take(55).join(' ');
    }
    return jobDescription ?? 'No description available';
  } else {
    return 'Error fetching description';
  }
}

Future<void> fetchLinkedInJobDesc(
    List<Map<String, String>> linkedInJobs) async {
  for (var job in linkedInJobs) {
    try {
      String jobDescription = await parseLinkedInDescription(job['proxyLink']!);
      job['description'] =
          jobDescription; // Store the description in the job map
      job['tags'] =
          await fetchLinkedInJobTags(job['proxyLink']!); // Fetch job tags
    } catch (e) {
      print('Error fetching LinkedIn description for ${job['title']}: $e');
      job['description'] =
          'Error fetching description'; // Optionally set an error message
      job['tags'] = 'No tags available'; // Set a default for tags
    }
  }
}

Future<String> parseLinkedInDescription(String jobUrl) async {
  final response = await http.get(Uri.parse(jobUrl));

  if (response.statusCode == 200) {
    var document = html.parse(response.body);
    var jobDetailsDiv =
        document.querySelector('div.description__text.description__text--rich');

    if (jobDetailsDiv != null) {
      var jobDescription =
          jobDetailsDiv.querySelector('div.show-more-less-html__markup');
      if (jobDescription != null) {
        String descriptionText = jobDescription.text.trim();
        List<String> words = descriptionText.split(' ');
        if (words.length > 50) {
          descriptionText = words.take(50).join(' ') + '...';
        }
        return descriptionText;
      }
    }

    return 'No description available'; // Added return for when jobDescription is null
  } else {
    return 'Error fetching description';
  }
}

// tags
Future<String> fetchLinkedInJobTags(String jobUrl) async {
  final response = await http.get(Uri.parse(jobUrl));

  if (response.statusCode == 200) {
    var document = html.parse(response.body);
    var tagElement = document
        .querySelectorAll('ul.description__job-criteria-list li')[2]
        .querySelector(
            'span.description__job-criteria-text.description__job-criteria-text--criteria');

    if (tagElement != null) {
      return tagElement.text.trim(); // Return the text inside the span
    } else {
      return 'No tag available'; // Handle case when span is not found
    }
  } else {
    return 'Error fetching tags';
  }
}
