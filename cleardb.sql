USE URFU_TASKS;
IF OBJECT_ID('dbo.register_buy', 'U') IS NOT NULL 
  DROP TABLE dbo.register_buy; 
GO
IF OBJECT_ID('dbo.shops', 'U') IS NOT NULL 
  DROP TABLE dbo.shops; 
GO
IF OBJECT_ID('dbo.products', 'U') IS NOT NULL 
  DROP TABLE dbo.products;
GO
IF OBJECT_ID('dbo.schedule', 'U') IS NOT NULL 
  DROP TABLE dbo.schedule; 