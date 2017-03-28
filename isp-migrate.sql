--References: 
--ISP DB Schema is 'old' schema, Cloud is 'new' schema in the script.
--For general types of information(like gender) I added two queries, one being commented.The commented one inserts values that are specified(instead of getting data from ISP DB)

--GENERAL

-- 'gender' table

CREATE SEQUENCE new.genderIDs START WITH 1; -- default value
ALTER TABLE new.gender ALTER COLUMN id SET DEFAULT nextval('new.genderIDs');
insert into new.gender(name)
select distinct sex from old.names where sex is not null;

--insert into new.gender(id, name) VALUES (1, 'Male'), (2, 'Female'), (3, 'Either'), (4, 'No preference');

--'grade' table

CREATE SEQUENCE new.gradeID START WITH 1;
ALTER TABLE new.grade ALTER COLUMN id SET DEFAULT nextval('new.gradeID');
insert into new.grade(name)
select distinct grade from old.tblgrade where grade is not null;

-- insert into new.grade(id, name) VALUES (1, 12), (2, 11), (3, 10), (4, 9), (5, 8), (6, 7), (7, 6), (8, 5), (9, 4), (10, 3), (11, 2), (12, 1), (13, 'SK'), (14, 'JK');


--'country' table*

CREATE SEQUENCE new.countryIDsss START WITH 1;
ALTER TABLE new.country ALTER COLUMN id SET DEFAULT nextval('new.countryIDsss');
insert into new.country(name)
select distinct country  from old.countries where country is not null;


--'citizenship' table

CREATE SEQUENCE new.citizenshipIDss START WITH 1; -- replace with any value
ALTER TABLE new.citizenship ALTER COLUMN id SET DEFAULT nextval('new.citizenshipIDss');
insert into new.citizenship (name)
select distinct citizenship from old.names where citizenship is not null;


--'city' table

CREATE SEQUENCE new.cityIDss START WITH 1; -- replace with any value
ALTER TABLE new.city ALTER COLUMN id SET DEFAULT nextval('new.cityIDss');

insert into new.city(name)
select distinct old.tblcityprov."cityprov" from old.tblcityprov;

insert into new.city(name)
select distinct "Custodian City"  from old.names WHERE "Custodian City" NOT IN(select name from new.city) AND "Custodian City" is not null;

insert into new.city(name)
select distinct old.names."Emergency City" from old.names WHERE "Emergency City" NOT IN(select name from new.city) AND "Emergency City" is not null;

insert into new.city(name)
select distinct emergcontact2city from old.names WHERE emergcontact2city NOT IN(select name from new.city) AND emergcontact2city is not null;

insert into new.city(name)
select distinct "Parent Address City" from old.names WHERE "Parent Address City" NOT IN(select name from new.city) AND "Parent Address City" is not null;

insert into new.city(name)
select distinct "School City" from old.tblschoollist WHERE "School City" NOT IN(select name from new.city) AND "School City" is not null;

insert into new.city(name)
select distinct "Agent City" from old.agentdemographic WHERE "Agent City" NOT IN(select name from new.city) AND "Agent City" is not null;


--'salutation' table

CREATE SEQUENCE new.salutationID START WITH 1; -- replace with any value
ALTER TABLE new.salutation ALTER COLUMN id SET DEFAULT nextval('new.salutationID');
insert into new.salutation(salut)
select distinct salutation from old.tblsalutation where salutation is not null;

-- new.salutation(id, salut) VALUES (1, 'Mr.'), (2, 'Mrs.'), (3, 'Ms.'), (4, 'Miss'), (5, 'Dr.'), (6, 'Prof.'), (7, 'Rev.'), (8, 'Mr.& Mrs.'), (9, 'Snr.');


--'language' table

CREATE SEQUENCE new.languageID START WITH 1; -- replace with any value
ALTER TABLE new.language ALTER COLUMN id SET DEFAULT nextval('new.languageID');
insert into new.language(name)
select distinct "Language" from old.tblprimarylanguages where "Language" is not null;

--'assessment' table

insert into new.assessment(id, name) VALUES (1, 'A'), (2, 'B'), (3, 'C'), (4, 'D'), (5, 'E'), (6, 'F');

--'state' table

insert into new.state(id, name) VALUES (1, 'Nunavut'), (2, 'Quebec'), (3, 'Northwest Territories'), (4, 'Ontario'), (5, 'British Columbia'), (6, 'Alberta'), (7, 'Saskatchewan'),
(8, 'Manitoba'), (9, 'Yukon'), (10, 'Newfoundland and Labrador'), (11, 'New Brunswick'), (12, 'Nova Scotia'), (13, 'Prince Edward Island'), (14, 'Not applicable');

--'referral' table

insert into new.referral(id, name) VALUES (1, 'Agent'), (2, 'TDSB Website'), (3, 'Education Fair'), (4, 'Friends or Family'), (5, 'Seminar');

--'shortterm' table

insert into new.shortterm(id, name) VALUES (1, 'Start Period to end period'), (2, 'Summer Camp'), (3, 'Summer ESL');

--'quadrant' table

insert into new.quadrant(id, name) VALUES (1, 'N'), (2, 'S'), (3, 'W'), (4, 'E'), (5, 'NW'), (6, 'NE'), (7, 'SW'), (8, 'SE');

--'evaluationresult' table

insert into new.evaluationresult(id, name) VALUES (1, 'Accepted'), (2, 'Deferred'), (3, 'Rejected');

-- 'schoolyear' table

CREATE SEQUENCE new.schoolyearID START WITH 1; -- replace with any value
ALTER TABLE new.schoolyear ALTER COLUMN id SET DEFAULT nextval('new.schoolyearID');
insert into new.schoolyear(name, active)
select distinct "School Year", False from old.names where "School Year" is not null;


-- 'program' table

insert into new.program(id, name)
select distinct programcode, programname from old.tblprograms where programname is not null;

--insert into new.program(id,name) VALUES (1, 'Exchange Program'),(2, 'Teacher Training'), (3, 'K-12 Full Year'), (4, 'K-12 1st Sem'),(5, 'K-12 2nd Sem'),(6, 'Short Term'),
--(7, 'Short Term Academic'),(8, 'Short Term Cultural'),(9, 'University Bridge Program'),(10, 'University Bridge Program 1st Sem'), (11, 'University Bridge Program 2nd Sem');


-- 'level' table

CREATE SEQUENCE new.levelIDs START WITH 1; -- replace with any value
ALTER TABLE new.level ALTER COLUMN id SET DEFAULT nextval('new.levelIDs');
insert into new.level(name)
select distinct "Level" from old.tblschoollist where "Level" is not null;

--insert into new.level(id, name) VALUES (1, 'No Preference'), (2, 'Elementary'), (3, 'Secondary'), (4, 'Elementary/Secondary');



--ADDRESSESS

--'address' table*(student's addresses available)

CREATE SEQUENCE new.addressID START WITH 1; -- replace with any value
ALTER TABLE new.address ALTER COLUMN id SET DEFAULT nextval('new.addressID');

--insert addresses for parents
insert into new.address(address, city_id, country_id, postal_code)
select * from (select distinct "Parent Address 1", new.city.id, new.country.id, "Parent Address Postal Code" from old.names as first_query
LEFT JOIN new.city ON new.city.name = first_query."Parent Address City"
LEFT JOIN new.country ON new.country.name = first_query."Parent Address Country") as second_query where second_query."Parent Address 1" is not null and "Parent Address 1" != '';
--insert addresses for custodians

insert into new.address(address, city_id, country_id, postal_code)
select * from (select distinct "Custodian Address 1", new.city.id, new.country.id, "Custodian Postal Code" from old.names as first_query
LEFT JOIN new.city ON new.city.name = first_query."Custodian City"
LEFT JOIN new.country ON new.country.name = first_query."Custodian Country") as second_query where second_query."Custodian Address 1" is not null and "Custodian Address 1" != '';

--inserts addresses for studenttorontocontactinformation 
--the country is always Canada
insert into new.address(address, city_id, country_id, postal_code)
select * from (select distinct "Emergency Address1", new.city.id, new.country.id, "Emergency Postal Code" from old.names as first_query
LEFT JOIN new.city ON new.city.name = first_query."Emergency City"
LEFT JOIN new.country ON new.country.name = 'Canada') as second_query where second_query."Emergency Address1" is not null and "Emergency Address1" != '';

--inserts addresses for schools
--the country is always Canada
insert into new.address(address, city_id, country_id, postal_code)
select * from (select distinct "School Address", new.city.id, new.country.id, "School PC" from old.tblschoollist as first_query
LEFT JOIN new.city ON new.city.name = first_query."School City"
LEFT JOIN new.country ON new.country.name = 'Canada') as second_query where second_query."School Address" is not null and "School Address" != '';


--'homestayaddress' table

insert into new.homestayaddress(id, city_id, address, postal_code, home_phone, cell_phone, fax)
select familyid, new.city.id, "Address Street", "Address PC", "Home Phone" , "Cell Phone", fax from old.tblhomestayinfo
LEFT JOIN new.city ON new.city.name = old.tblhomestayinfo."Address City";


--'agencyaddress' table

insert into new.agencyaddress(id, city_id, country_id, address, second_address, postal_code, other_phone, work_phone, cell_phone, fax)
select distinct on (agid) 
old.agentdemographic.agid, 
new.city.id, new.country.id, old.agentdemographic."Agent Address1", old.agentdemographic."Agent Address2", old.agentdemographic."Agent Postal Code", 
old.agentdemographic."Agency Other Phone", old.agentdemographic."Oversea Phone", old.agentdemographic.contact2cellphone, old.agentdemographic."Oversea Fax"
from old.agentdemographic
LEFT JOIN new.country ON new.country.name = old.agentdemographic."Oversea Country"
LEFT JOIN new.city ON new.city.name = old.agentdemographic."Agent City"
GROUP BY agid, country.id, city.id;



--STUDENTS

--'studentstatus' table
CREATE SEQUENCE new.studentstatusID START WITH 1; -- replace with any value
ALTER TABLE new.studentstatus ALTER COLUMN id SET DEFAULT nextval('new.studentstatusID');
insert into new.studentstatus(name)
select status from old.names where status is not null;

--insert into new.studentstatus(id, name) VALUES(1, 'Status 1'),(2, 'Status 2'), (3, 'Status 3');

-- 'studenttorontocontactinformation' table

insert into new.studenttorontocontactinformation(id, gender_id, address_id, first_name, last_name, relationship_with_student, home_phone, cell_phone, fax, email)
(select old.names.studentid, new.gender.id, new.address.id, split_part(old.names."Emergency Contact Name", ' ', 1) AS first_name, split_part(old.names."Emergency Contact Name", ' ', 2) AS last_name, 
old.names.RelationshipToEmerg1, old.names."Emergency Phone","Emergency Cell", old.names."Emergency Fax", old.names."Emergency email" from old.names
LEFT JOIN new.gender ON new.gender.name = old.names.sex
LEFT JOIN new.address ON new.address.address = old.names."Emergency Address1" OR new.address.address = old.names."Emergency Address2");


-- 'studentcurrentstatus' table **

CREATE SEQUENCE new.studentcurrentstatusID START WITH 1; -- replace with any value
ALTER TABLE new.studentcurrentstatus ALTER COLUMN id SET DEFAULT nextval('new.studentcurrentstatusID');
insert into new.studentcurrentstatus(name)
select distinct description from old.tblrecstatus WHERE description is not null;

--Insert into new.studdentcurrentstatus(id, name) VALUES (1, 'In Home Country'), (2, 'Attending School In Canada'), (3, 'Visitor to Canada'), (4, 'Permanent rezident');


-- 'studentcustodian' table

CREATE SEQUENCE new.studentcustodianID START WITH 1; -- replace with any value
ALTER TABLE new.studentcustodian ALTER COLUMN id SET DEFAULT nextval('new.studentcustodianID');
insert into new.studentcustodian(student_id, custodian_id)
select studentid, custodianid from old.tblstudentcustodianlinking;

-- 'studentschoolinformation' table

insert into new.studentschoolinformation(id, current_school_city_id, last_grade_completed_id, previous_school_city_id, current_school_name, previous_school_name)
(select old.names.studentid, new.city.id, new.grade.id, new.city.id, old.names."Current School Name", old.names."Student Previous School1"
from old.names
LEFT JOIN new.grade ON new.grade.name = old.names.grade
LEFT JOIN old.tblschoollist ON old.tblschoollist."School Name" = old.names."Current School Name" OR old.tblschoollist."School Name" = old.names."Student Previous School1"
LEFT JOIN new.city ON new.city.name = old.tblschoollist."School City");


-- 'student' table'

insert into new.student(id,citizenship_id, grade_id, gender_id, parents_id, address_id, school_information_id, toronto_contact_information_id,
country_of_birth_id, first_name, last_name, pref_name, dob, fee_paying, homestay_required, contact_telephone, contact_cell_phone, historical_current_fte, next_fte, current_fte, created, updated)

(select old.names.studentid, new.citizenship.id, new.grade.id, new.gender.id, new.parents.id, new.address.id, new.studentschoolinformation.id, new.studenttorontocontactinformation.id,
new.country.id, old.names.Fname, old.names.Lname, old.names."Called Name", old.names."Birth Date", old.names.SDpaysHS::boolean, old.names.HSRequired::boolean,
old.names."Emergency Phone", old.names."Emergency Cell", FTE, FTE1, FTE2, NOW(), NOW() FROM old.names
LEFT JOIN new.citizenship ON new.citizenship.name = old.names.citizenship
LEFT JOIN new.grade ON new.grade.name = old.names.grade
LEFT JOIN new.gender ON new.gender.name = old.names.sex
LEFT JOIN new.parents ON new.parents.id = old.names.studentid
LEFT JOIN new.address ON new.address.id = old.names.studentid
LEFT JOIN new.studentschoolinformation ON new.studentschoolinformation.id = old.names.studentid
LEFT JOIN new.studenttorontocontactinformation ON new.studenttorontocontactinformation.id = old.names.studentid
LEFT JOIN new.country ON new.country.name = old.names.studentcountry);


-- 'studentlanguage' table 

CREATE SEQUENCE new.studentlanguageID START WITH 1; -- replace with any value
ALTER TABLE new.studentlanguage ALTER COLUMN id SET DEFAULT nextval('new.studentlanguageID');
insert into new.studentlanguage(language_id, student_id)
select new.language.id, old.names.studentid
from old.names
LEFT JOIN new.language ON new.language.name = old.names."Primary Language";


-- 'parents' table

insert into new.parents(id, father_first_name, father_last_name, father_email, mother_first_name, mother_last_name, mother_email, home_phone, cell_phone, work_phone, fax)
select studentid, split_part("Parent Father Name", ',', 1) AS father_first_name, split_part("Parent Father Name", ',', 2) AS father_last_name, "Parent Email", 
split_part("Parent Mother Name", ',', 1) AS mother_first_name, split_part("Parent Mother Name", ',', 2) AS mother_last_name,"Parent Email", "Parent Home Phone", "Parent Home Cell", "Parent Work Phone", "Parent Home Fax" from old.names;



--HOMESTAYS

--'homestaytypeplacement' table

CREATE SEQUENCE new.homestaytypeplacementID START WITH 1; -- replace with any value
ALTER TABLE new.homestaytypeplacement ALTER COLUMN id SET DEFAULT nextval('new.homestaytypeplacementID');
insert into new.homestaytypeplacement(name) 
select distinct "Type of Placement" from old.names WHERE "Type of Placement" is not null;

--insert into new.homestaytypeplacement(id, name) VALUES (1, 'District'),(2, 'Agent Appointed'),(3, 'Biological'), (4, 'Custodian'),(5, 'District Appointed'), (6, 'Other'),(7, 'Relatives');


-- 'homestaytype' table**

CREATE SEQUENCE new.homestaytypeID START WITH 1; -- replace with any value
ALTER TABLE new.homestaytype ALTER COLUMN id SET DEFAULT nextval('new.homestaytypeID');
insert into new.homestaytype(name)
select distinct hometypedescription from old.tblhomestaytypes where hometypedescription is not null;

--insert into new.homestaytype(id, type) VALUES (1, 'Potential'), (2, 'Active'), (3, 'Inactive');


--'currenthomestaystatus' table**

CREATE SEQUENCE new.currenthomestaystatusID START WITH 1; -- replace with any value
ALTER TABLE new.currenthomestaystatus ALTER COLUMN id SET DEFAULT nextval('new.currenthomestaystatusID');
insert into new.currenthomestaystatus(name)
select distinct homestaystatus from old.tblhomestaystatus WHERE homestaystatus is not null;

--'livingwith' table

insert into new.livingwith(id, name) VALUES (1, 'Parent'), (2, 'Custodian'), (3, 'Friend'), (4, 'Family Friend'), (5, 'Homestay'), (6, 'Relative'), (7, 'Self'), 
(8, 'Uncle'), (9, 'Aunt'), (10, 'Grandparents'), (11, 'Cousin');


--'homestayhostdetails' table

CREATE SEQUENCE new.homestayhostdetailsID START WITH 1; -- replace with any value
ALTER TABLE new.homestayhostdetails ALTER COLUMN id SET DEFAULT nextval('new.homestayhostdetailsID');
insert into new.homestayhostdetails(name)
select distinct relationship from old.relationshiptable where relationship is not null;

--insert into new.homestayhostdetails(id, name) VALUES (1, 'Father-in-law'),(2, 'Friend'), (3, 'Grandfather'), (4, 'Grandmother'), (5, 'Grandparent'), (6, 'Grandparents'),
--(7, 'Homestay'),(8, 'Husband'), (9, 'Mother'), (10, 'Mother-in-law'),(11, 'Parent'),(12, 'Parents'),(13, 'Rotary'),(14, 'Son'),(15, 'Uncle'),(16, 'Wife');

-- 'homestaydescription' table

insert into new.homestaydescription(id, her_first_name, her_last_name, her_occupation, her_employer, her_work_phone, her_cell_phone, her_email, 
his_first_name, his_last_name, his_occupation, his_employer, his_work_phone, his_cell_phone, his_email, created, updated, pets, family_info, rooms_info, home_info, comments, activities_hobbies)
(select familyid, "Her First Name", "Her Last Name", "Her Occupation", heremployer, "Her Business Phone", "Her Cell Phone Number", heremailaddress,
"His First Name", "His Last Name", "His Occupation", hisemployer, "His Business Phone", "His Cell Phone Number", hisemailaddress, NOW(), NOW(), pets, familyinfo, roominfo, homeinfo, "Comments", "Interests & Hobbies"  from old.tblhomestayinfo);


-- 'homestaystatusapplicationchecklist' table

insert into new.homestaystatusapplicationchecklist(id, application_proccessed_value, application_proccessed_date, rejected_value, rejection_letter_date, rejection_notes, reference_letter_value, crc_value,
crc_date, workshop_value, homevisit_value, homevisit_date, revisit_date)
select familyid, application::integer::boolean, "Application Processed Date", rejected::integer::boolean, rejectionletterdate, rejectionreason, reference::integer::boolean, 
"Criminal Record"::integer::boolean, "CRC Issue Date", workshop::integer::boolean, "Home Visit"::integer::boolean, "Home Visit Date", "Re-Visit Date" from old.tblhomestayinfo;


-- 'homestaystatus' table

insert into new.homestaystatus(id, application_checklist_id, home_visit_date, re_visit_date, orientation, rejected, rejected_date, reference, child_abuse_registry, verification_notes, rejection_reasons,
her_crc_expire_date, his_crc_expire_date, created, updated)
select familyid, familyid, "Home Visit Date", "Re-Visit Date", orientation::integer::boolean, rejected::integer::boolean, rejectionletterdate, reference::integer::boolean, "Child Abuse Registry"::integer::boolean, notes, rejectionreason,
"His Criminal Record Date", "Her Criminal Record Date", NOW(), NOW() from old.tblhomestayinfo;


-- 'homestayfamilymembers' table

CREATE SEQUENCE new.homestayfamilymembersID START WITH 1; -- replace with any value
ALTER TABLE new.homestayfamilymembers ALTER COLUMN id SET DEFAULT nextval('new.homestayfamilymembersID');
insert into new.homestayfamilymembers(gender_id, homestay_id, last_name, first_name, relationship, date_of_birth, age, school_occupation, notes, crc_issue_date, crc_expiry_date, crc_require, created, updated)
select new.gender.id, hsfamilyid, "First Name", "Last Name", relationship, birthdate, age::integer, occupation, notes, "CRC Issue Date", "CRC Renewal Date", crc_not_required::integer::boolean, now(), now() from old.tblhomestayfamilyinfo
LEFT JOIN new.gender ON new.gender.name = tblhomestayfamilyinfo.gender;


-- 'homestayfamilyotherhomeoccupants' table

CREATE SEQUENCE new.homestayfamilyotherhomeoccupantsID START WITH 1; -- replace with any value
ALTER TABLE new.homestayfamilyotherhomeoccupants ALTER COLUMN id SET DEFAULT nextval('new.homestayfamilyotherhomeoccupantsID');
insert into new.homestayfamilyotherhomeoccupants(homestay_id, other_home_occupants)
select familyid, familymembers from old.tblhomestayinfo where familymembers is not null;


-- 'homestaybasichostinfo' table

insert into new.homestaybasichostinfo(id, her_citizenship_id, his_citizenship_id, transport_id, hosting_history, entry_date, modification_date, start_date, available_from_date, available_to_date, full_time, summer_camp, winter_camp, short_term, short_term_only, short_term_optional, emergency, religion, created, updated)
select familyid, new.citizenship.id, new.citizenship.id, new.homestaybasichostinfotransport.id, "Hosting History", "Entry Date", "Modification Date", "Entry Date", "Available From", "Available To", 
fulltime::integer::boolean, "Summer Camp"::integer::boolean, "Winter Camp"::integer::boolean, "Short-Term"::integer::boolean, "Short Term Only"::integer::boolean, 
"Short Term Optional"::integer::boolean, emergency::integer::boolean, religion, now(), now() from old.tblhomestayinfo
LEFT JOIN new.homestaybasichostinfotransport ON new.homestaybasichostinfotransport.name = old.tblhomestayinfo.transporttoschool
LEFT JOIN new.citizenship ON new.citizenship.name = old.tblhomestayinfo."Her Nationality" OR new.citizenship.name = old.tblhomestayinfo."His Nationality";


-- 'homestaypictures' table

CREATE SEQUENCE new.homestaypicturesID START WITH 1; -- replace with any value
ALTER TABLE new.homestaypictures ALTER COLUMN id SET DEFAULT nextval('new.homestaypicturesID');
insert into new.homestaypictures(homestay_id, file_name, file_path, title_name, decription, uploaded) --description(typo in column name)
select familyid, imagecaption, hyperpath, imagecaption, description, now() from old.tblhomestayinfo;


-- 'safetyinformation' table

insert into new.safetyinformation(id, fire_extinguisher, smoke_detector, any_smoker, co2_detector, security_system)
select familyid, fireextinguishers::integer::boolean, smokedetectors::integer::boolean, anysmokers::integer::boolean, co2detectors::integer::boolean, securitysystem::integer::boolean from old.tblhomestayinfo;


-- 'homestaybasichostinfotransport' table

CREATE SEQUENCE new.homestaybasichostinfotransportID START WITH 1; -- replace with any value
ALTER TABLE new.homestaybasichostinfotransport ALTER COLUMN id SET DEFAULT nextval('new.homestaybasichostinfotransportID');
insert into new.homestaybasichostinfotransport(name)
select transportmethod from old.tblTransportMethod;

-- 'homestaydocrepository' table

insert into new.homestaydocrepository(id, file_name, file_path, uploaded, homestay_id)
select fileid, file_name, file_path, createdate, hostid from old.tblrelatedfiles;


-- 'homestaychronologicalnotes' table
CREATE SEQUENCE new.homestaychronologicalnotesID START WITH 1; -- replace with any value
ALTER TABLE new.homestaychronologicalnotes ALTER COLUMN id SET DEFAULT nextval('new.homestaychronologicalnotesID');
insert into new.homestaychronologicalnotes(homestay_id, note_text, created, updated)
select familyid, note, datetime, now() from old.tblhomestaynote;


-- 'homestaypayment' table

CREATE SEQUENCE new.homestaypaymentID START WITH 1; -- replace with any value
ALTER TABLE new.homestaypayment ALTER COLUMN id SET DEFAULT nextval('new.homestaypaymentID');
insert into new.homestaypayment(payment_id, payment_date, amount_paid, student_name, student_id, homestay_id, start_date, end_date, notes, lock_status, created, updated)
select pmtid, amtpmtdate, amt, (select old.names.Fname || ' ' || old.names.Lname), old.tblpaymentstovendors_homestay.studentid, familyid, pmtfromdate, pmttodate, "Comments", false, dateposted, now() from old.tblpaymentstovendors_homestay
LEFT JOIN old.names ON old.names.studentid = old.tblpaymentstovendors_homestay.studentid;


-- 'paymenttype' table

CREATE SEQUENCE new.paymenttypeID START WITH 1; -- replace with any value
ALTER TABLE new.paymenttype ALTER COLUMN id SET DEFAULT nextval('new.paymenttypeID');
insert into new.paymenttype(name)
select distinct paymenttype from old.tblpaymenttype where paymenttype is not null;

--insert into new.paymenttype(id, name) VALUES (1, 'Wire Transfer'),(2, 'Cheque'), (3, 'Cash'), (4, 'Board Office Cheque');


-- 'homestayreasonforleaving' table

CREATE SEQUENCE new.homestayreasonforleavingID START WITH 1; -- replace with any value
ALTER TABLE new.homestayreasonforleaving ALTER COLUMN id SET DEFAULT nextval('new.homestayreasonforleavingID');

insert into new.homestayreasonforleaving (name)
select reasondescription from old.tblhomestaychangereasons where reasondescription is not null;



--'homestay' table

Insert into new.homestay(id, gender_preference_id, homestay_type_id, address_id, safety_information_id, homestay_description_id, homestay_status_id, homestay_basic_host_info_id, 
other_home_occupants_id, email, family_name, pref_name, number_of_rooms, rooms_available, vendor, web_id, homestay_name, pref_salut, vegetarian, smoke, created, updated)
select familyid, new.gender.id, new.homestaytype.id, familyid, familyid, familyid, familyid, familyid, new.homestayfamilyotherhomeoccupants.id, 
email, homestay, "Parent Names Preferred", "Number of rooms"::integer, " Rooms Offered", vendornum, web_familyid, "HomeStay Parent", "Parent Salutation Preferred", vegetarian::boolean, smoke::boolean, NOW(), NOW() 
from old.tblhomestayinfo
LEFT JOIN new.homestaytype ON new.homestaytype.name = old.tblhomestayinfo.homestaytype
LEFT JOIN new.gender ON new.gender.name = old.tblhomestayinfo.prefer
LEFT JOIN new.language ON new.language.name = old.tblhomestayinfo."Other Languages Spoken"
LEFT JOIN new.homestayfamilyotherhomeoccupants ON new.homestayfamilyotherhomeoccupants.homestay_id = old.tblhomestayinfo.familyid;


-- 'homestaystudents' table*

CREATE SEQUENCE new.homestaystudentsID START WITH 1; -- replace with any value
ALTER TABLE new.homestaystudents ALTER COLUMN id SET DEFAULT nextval('new.homestaystudentsID');

insert into new.homestaystudents (student_id, homestay_id, current_homestay_status_id, type_placement_id, host_details_id, reason_for_leaving_id, date_joined_family, date_left_family, lock_status)
select old.tblstudenthomestaylinking.studentid, old.tblstudenthomestaylinking.familyid, new.currenthomestaystatus.id, new.homestaytypeplacement.id, new.homestayhostdetails.id, new.homestayreasonforleaving.id, 
old.tblstudenthomestaylinking."Date Joined Family", old.tblstudenthomestaylinking."Date Left Family", FALSE  from old.tblstudenthomestaylinking
LEFT JOIN old.names ON old.names.studentid = old.tblstudenthomestaylinking.studentid
LEFT JOIN new.currenthomestaystatus ON new.currenthomestaystatus.name = old.tblstudenthomestaylinking.studentstatus
LEFT JOIN new.homestaytypeplacement ON old.names."Type of Placement" = new.homestaytypeplacement.name
LEFT JOIN new.homestayreasonforleaving ON new.homestayreasonforleaving.name = old.names.exitreason
LEFT JOIN new.homestayhostdetails ON new.homestayhostdetails.name = old.names."Host Details";


--SCHOOLS


-- 'school' table


insert into new.school(id, name, shortname, principal, principalemail, gradefrom , gradeto, phone, fax, schoolcapacity, notes)
select "School ID"::integer, "School Name", "School Short Name", "School Principal", "School Principal EMail", grades , grades, "School Phone", "School Fax", seats, notes from old.tblschoollist;


-- 'homestayschool' table

CREATE SEQUENCE new.homestayschoolID START WITH 1; -- replace with any value
ALTER TABLE new.homestayschool ALTER COLUMN id SET DEFAULT nextval('new.homestayschoolID');

insert into new.homestayschool(school_id, homestay_id)
select hsschoolid, familyid from old.tblhomestayschools;


-- 'studentschool' table

CREATE SEQUENCE new.studentschoolID START WITH 1; -- replace with any value
ALTER TABLE new.studentschool ALTER COLUMN id SET DEFAULT nextval('new.studentschoolID');

insert into new.studentschool(school_id, student_id, option_number, accepted)
select "School ID"::integer, studentid, programcode, currentschool from old.tblstudentschoolnamelinking;


-- 'custodian' table


insert into new.custodian(id, gender_id, address_id, status_in_canada_id, first_name, last_name, home_phone, work_phone, cell_phone, email, fax, created, updated)
(select distinct on(custodianid) *, now(),now() from
(select custodianid, new.gender.id, new.address.id, new.studentcurrentstatus.id, "Custodian First Name",
 "Custodian Last Name", "Custodian Phone", "Custodian Phone", "Custodian Phone", "Custodian email", "Custodian Fax" from old.names as first_query
LEFT JOIN new.gender ON new.gender.name = first_query."Custodian Gender"
LEFT JOIN new.address ON new.address.address = first_query."Custodian Address 1"
LEFT JOIN new.studentcurrentstatus ON studentcurrentstatus.name = first_query.studentstatus) as second_query where custodianid is not null);


--AGENTS

--'agentlocale' table

insert into new.agentlocale(id, locale) VALUES (1,'Overseas'), (2, 'Relations'), (3, 'Static'), (4, 'Example');

--'agentposition' table

insert into new.agentposition(id, position)
select distinct agid, agentposition from old.agentdemographic where agentposition is not null;

--insert into new.agentposition(id, position) VALUES (1, 'Principal representative'),(2, 'Secondary representative'), (3, 'Third representative'), (4, 'Fourth representative');


--'agenttype' table*

insert into new.agenttype(id, type) VALUES (1, 'Type 1'), (2, 'Type 2'), (3, 'Type 3');



--'agency' table

insert into new.agency(id, address_id, name, trade_name, web, target_market, notes, total_comission_fee, total_comission_pa, agency_bn, percentage, agency_payment_comment)
select agid, agid, "Agency Name", "Trade Name", "agentweb", "agenttargetmarket", "Comments" , ee, "Bank Payable", "Agency BN", percentage::float, "Agent Payment Comment" from old.agentdemographic;


--'agentbranch' table

CREATE SEQUENCE new.agentbranchID START WITH 1; -- replace with any value
ALTER TABLE new.agentbranch ALTER COLUMN id SET DEFAULT nextval('new.agentbranchID');
insert into new.agentbranch(branch_representative_id, address_id, agency_id, name, headquarter)
select "Bank Branch Number"::integer, agid, agid, "Bank Name", False from old.agentdemographic;


--'agencybankinginformation' table

insert into new.agencybankinginformation(id, bank_name, address_one, address_two, bank_branch, account_number, account_holder_name, account_comments, ee_number, sort, code, vendor_number, account_to_be_dr, date, account_per_budget, project, bank_payable, payee_agency_name, gst, payee_agency_description, created, updated)
select agid, "Bank Name", "Bank Address 1", "Bank Address 2", "Bank Branch Number", "Account Number"::integer, "Account Holder Name", "Comments", ee, sort, code::integer, "Vendor", 
"Acct to be DR", "Date", "Acct as per budget", project, "Bank Payable", "Payee/Agency Name", gst, description, now(), now() from old.agentdemographic;


--'agencydocument' table

insert into new.agencydocument(id, file_name, file_path, uploaded, download_permission_for_agency, delete_permission_for_agency, uploaded_by_user, agency_id, agent_id)
select fileid, file_name, file_path, createdate, false, false, false, agentid, agentid from old.tblrelatedfiles;


--'agent' table

insert into new.agent(id, address_id, position_id, salut_id, type_id, agency_id, source_country_id, branch_id, first_name, last_name, status, agent_agreement, original_date, renewal_date, expiration_date, agent_email_address, agent_sin, created, updated)
select * from(select distinct on (old.agentdemographic.agid) old.agentdemographic.agid, 
old.agentdemographic.agid,
new.agentposition.id as agentposition, 
new.salutation.id as agentsalution, 
new.agenttype.id, 
new.agencyaddress.id, 
new.country.id,
new.agentbranch.id, 
split_part(old.agentdemographic."Agent Contact", ' ', 1) AS first_name, 
split_part(old.agentdemographic."Agent Contact", ' ', 2) AS last_name, 
old.agentdemographic."Type", --(Active, Inactive)
old.agentdemographic."Agreement Start Date", 
old.agentdemographic."Date", 
old.agentdemographic."Agreement End Date", 
old.agentdemographic."Agent EMail", 
old.agentdemographic."Agent SIN", now(), now()
FROM old.agentdemographic
LEFT OUTER JOIN new.agentposition ON new.agentposition.position = old.agentdemographic.agentposition 
LEFT OUTER JOIN new.salutation ON new.salutation.salut = old.agentdemographic.agentsalutation 
LEFT OUTER JOIN new.agenttype ON new.agenttype.type = old.agentdemographic."Type"
LEFT OUTER JOIN new.agencyaddress ON new.agencyaddress.id = old.agentdemographic.agid
LEFT OUTER JOIN new.country ON new.country.name = old.agentdemographic."Oversea Country"
LEFT OUTER JOIN new.agentbranch ON new.agentbranch.branch_representative_id = old.agentdemographic."Bank Branch Number"::integer
order by old.agentdemographic.agid) as query_result WHERE CASE query_result."Type" WHEN 'Active' THEN true ELSE false END;


--'studentagent' table

CREATE SEQUENCE new.studentagentID START WITH 1; -- replace with any value
ALTER TABLE new.studentagent ALTER COLUMN id SET DEFAULT nextval('new.studentagentID');
insert into new.studentagent(student_id, agent_id)
select studentid, "Agent Id" from old.names where "Agent Id" is not null;




--USERS/APPLICATIONS

--'applicationfeepaymenttype' table

insert into new.applicationfeepaymenttype(id,name) VALUES (1, 'Bank Draft'), (2, 'Certified Cheque'), (3, 'Wire Transfer'), (4, 'Other');

--'applicationfilledby' table
insert into new.applicationfilledby(id, name) VALUES (1, 'Student'), (2, 'Parent'), (3, 'Agent'), (4, 'Other');

--'applicationtype' table
insert into new.applicationtype(id, name) VALUES(1, 'Fulltime'),(2, 'Short Term');

--'applicationsreviewedfrom' table
insert into new.applicationsreviewedfrom(id, name) VALUES (1, 'Custodian'), (2, 'Agent'), (3, 'Other');

--'applicationssubmittedby' table
insert into new.applicationssubmittedby(id, name) VALUES (1, 'Apply Portal'), (2, 'In person'), (3, 'Courier'), (4, 'Mail');


-- 'users' table**

CREATE SEQUENCE usersID START WITH 1; -- replace with any value
ALTER TABLE new.users ALTER COLUMN id SET DEFAULT nextval('usersID');
insert into new.users(created, updated, password, email, firstname, lastname)
select now(), now(), pw, email, split_part("stafffullname", ' ',1), split_part("stafffullname", ' ',2) from old.tblpwtable;

insert into new.users(created, updated, password, email, firstname, lastname)
select now(), now(), pw, "HS Coord", split_part("HS Coordinator", ' ',1), split_part("HS Coordinator", ' ',2) from old.tblpwtable;


-- 'tuition' table**

insert into new.tuition(id, program_id, school_year_id, start_date, tuition_fee)
select second_query.receiptdetailid, second_query.programcode::integer, second_query.id, second_query.paymentdate, second_query.fee
from (select receiptdetailid, programcode, new.schoolyear.id, paymentdate, fee from old.tblreceiptdetails as first_query
LEFT JOIN new.schoolyear ON new.schoolyear.name = first_query."School Year") as second_query where second_query.programcode is not null and second_query.programcode != '';


CREATE SEQUENCE new.receiptID START WITH 1; -- replace with any value
ALTER TABLE new.receipt ALTER COLUMN id SET DEFAULT nextval('new.receiptID');

insert into new.receipt(receipt_number, created, invoice_number, total_amount_paid, student_id, lock_status)
select receiptno, receiptdate, invoicenumber, totalprice, studentid, neverexport::integer::boolean from old.tblreceiptdetails;








