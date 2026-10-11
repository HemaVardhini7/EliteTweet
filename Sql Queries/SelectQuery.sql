-- Fifth

USE TwitterDB;
GO

SELECT * FROM Users;

SELECT * FROM Tweets;

SELECT * FROM Followers;

SELECT * FROM Likes;

SELECT * FROM Comments;

SELECT * FROM Retweets;

SELECT * FROM Reports;

SELECT * FROM OtpVerification;

SELECT * FROM ContentModeration
ORDER BY ModerationId DESC;

SELECT Email, Username, ProfilePicture
FROM Users;

SELECT * FROM sys.tables;


SELECT TOP 1 *
FROM Users;