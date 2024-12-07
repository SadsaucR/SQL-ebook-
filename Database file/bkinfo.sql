USE [master]
GO
/****** Object:  Database [ebook]    Script Date: 2024/12/7 下午 04:23:52 ******/
CREATE DATABASE [ebook]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ebook', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ebook.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ebook_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ebook_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ebook] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ebook].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ebook] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ebook] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ebook] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ebook] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ebook] SET ARITHABORT OFF 
GO
ALTER DATABASE [ebook] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ebook] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ebook] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ebook] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ebook] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ebook] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ebook] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ebook] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ebook] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ebook] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ebook] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ebook] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ebook] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ebook] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ebook] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ebook] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ebook] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ebook] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ebook] SET  MULTI_USER 
GO
ALTER DATABASE [ebook] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ebook] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ebook] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ebook] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ebook] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ebook] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [ebook] SET QUERY_STORE = ON
GO
ALTER DATABASE [ebook] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [ebook]
GO
/****** Object:  Table [dbo].[bookinfo]    Script Date: 2024/12/7 下午 04:23:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bookinfo](
	[bid] [int] IDENTITY(1,1) NOT NULL,
	[bname] [nvarchar](50) NOT NULL,
	[price] [money] NOT NULL,
	[status] [nvarchar](50) NOT NULL,
	[type] [nvarchar](50) NULL,
 CONSTRAINT [PK_bookinfo] PRIMARY KEY CLUSTERED 
(
	[bid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[inventory]    Script Date: 2024/12/7 下午 04:23:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[inventory](
	[bid] [int] NOT NULL,
	[wid] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[setdate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_inventory] PRIMARY KEY CLUSTERED 
(
	[bid] ASC,
	[wid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[trade]    Script Date: 2024/12/7 下午 04:23:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trade](
	[bid] [int] NOT NULL,
	[cname] [nvarchar](50) NOT NULL,
	[transactionType] [nvarchar](50) NOT NULL,
	[tquantity] [int] NOT NULL,
	[ransactionDate] [datetime2](7) NULL,
	[remarks] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[userinfo]    Script Date: 2024/12/7 下午 04:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[userinfo](
	[cname] [nvarchar](50) NOT NULL,
	[password] [nvarchar](50) NOT NULL,
	[cellphone] [nvarchar](50) NOT NULL,
	[address] [nvarchar](50) NOT NULL,
	[birthday] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[warehouse]    Script Date: 2024/12/7 下午 04:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[warehouse](
	[wid] [int] IDENTITY(1,1) NOT NULL,
	[wname] [nvarchar](50) NOT NULL,
	[location] [nvarchar](50) NOT NULL,
	[setdate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_werehouse] PRIMARY KEY CLUSTERED 
(
	[wid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[bookinfo] ON 

INSERT [dbo].[bookinfo] ([bid], [bname], [price], [status], [type]) VALUES (1, N'JavaScript', 550.0000, N'有庫存', N'網頁開發')
INSERT [dbo].[bookinfo] ([bid], [bname], [price], [status], [type]) VALUES (3, N'HarryPotter', 418.0000, N'有庫存', N'奇幻小說')
INSERT [dbo].[bookinfo] ([bid], [bname], [price], [status], [type]) VALUES (4, N'100種京都', 380.0000, N'有庫存', N'旅遊')
INSERT [dbo].[bookinfo] ([bid], [bname], [price], [status], [type]) VALUES (6, N'張忠謀自傳全集', 1100.0000, N'有庫存', N'人物傳記')
SET IDENTITY_INSERT [dbo].[bookinfo] OFF
GO
INSERT [dbo].[inventory] ([bid], [wid], [quantity], [setdate]) VALUES (1, 2, 20, CAST(N'2024-12-07T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[inventory] ([bid], [wid], [quantity], [setdate]) VALUES (3, 3, 5, CAST(N'2024-12-07T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[inventory] ([bid], [wid], [quantity], [setdate]) VALUES (4, 2, 1, CAST(N'2024-12-07T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[inventory] ([bid], [wid], [quantity], [setdate]) VALUES (6, 3, 5, CAST(N'2024-12-07T00:00:00.0000000' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[warehouse] ON 

INSERT [dbo].[warehouse] ([wid], [wname], [location], [setdate]) VALUES (2, N'倉庫A', N'東側', CAST(N'2024-12-07T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[warehouse] ([wid], [wname], [location], [setdate]) VALUES (3, N'倉庫B', N'西側', CAST(N'2024-12-07T00:00:00.0000000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[warehouse] OFF
GO
ALTER TABLE [dbo].[inventory]  WITH CHECK ADD  CONSTRAINT [FK_inventory_bookinfo] FOREIGN KEY([bid])
REFERENCES [dbo].[bookinfo] ([bid])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[inventory] CHECK CONSTRAINT [FK_inventory_bookinfo]
GO
ALTER TABLE [dbo].[inventory]  WITH CHECK ADD  CONSTRAINT [FK_inventory_werehouse] FOREIGN KEY([wid])
REFERENCES [dbo].[warehouse] ([wid])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[inventory] CHECK CONSTRAINT [FK_inventory_werehouse]
GO
USE [master]
GO
ALTER DATABASE [ebook] SET  READ_WRITE 
GO
