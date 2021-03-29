Return-Path: <SRS0=0gGY=I3=lists.openwall.com=kernel-hardening-return-21075-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E684C433C1
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Mar 2021 11:25:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0BA0861938
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Mar 2021 11:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BA0861938
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21075-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11737 invoked by uid 550); 29 Mar 2021 11:25:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26158 invoked from network); 29 Mar 2021 10:17:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ndakduNECvlXvwsXG+bMQPlVgAxjZl6OHanQU83MD3w=;
 b=mYSQZlTdwi9Lc7oLruyfuwxtyxrkXpSiX7C9xbiDxb1FwW9olVK+EwoWutVlOi5WHRd1
 TL5Ii54L9oz2vVH7b4NAiVCGzk3IGCrPVZmnct8u6DkySIQGQARCCPXow2nYv+kKuJD3
 KOkAK1yqW3sYM6Nm/6mtmO0t90OlNz6zBQyDT4NvE++fUUC1zet8XS+iprhvKcEc0aLM
 vj8XQRlEQZFtne339zbNPJlvHTuhLAjJCU6Ro0t05qHR+IfzO7xvTkPY0rCNoGzNSNxH
 iYMGxawTdvJcwSFXLVoGsWGOQBjlUmbhQ7WJd8o45rYjDY1aL3HHscJNKuy9Am6kMg0j mA== 
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbfwTSqzdFAsmxyqzS2u1rNVpxOUBrcICDomOzL6jAMIFe39AmgDCLbBOcLnvIfP0CuBNebKWeuKfwcBbfbC9RisYTnOXnEWwRES81b2lRWX7TrA0YIIh48CyR1TQ7jefOvR3fPubPQE4OP/pjW+HUx+ZGHEVBFPFqlmjXkhN1gRkvwOIOVgcaCXFuzaf/2kKclFSlD/xAATdUKPyQTXnhroAUE0nE3g5fJpFDxWGSpUBuNw54BZD6rKVo5/AUA31xeFQWo8ACfC6I+aR/7+VL4bVmPAhh8OLUxvFEEJ541TQ044MxRcTzOh6pz5mn01z4yxKtu5m0FQL+VMxyzG/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndakduNECvlXvwsXG+bMQPlVgAxjZl6OHanQU83MD3w=;
 b=WJ5RD1lkiL/XUEzT83lzhyeHWPOEcOd0vvMmGujkQde/w08tS6JZPFgViPIUzKpecwpcJFntCE+sR0kad0kRMWHT2M2A+TjwiYrSoUpO+IV15BYojbP5Ok2PaLVEJbCUpO8riQOnybLNWMsVKfQK17k46E8uGQeNJLBr4e9UcYogo8M7o38vgbWKBoTdvUF0uYjo04AsXk5776NnbYNRzz1IzB+xgBBAM8rE56CzFK+huqoWcOVrqkQKL4WPbOwVpCC//aSQPbrEmPWKOeDcUcmnf6a48dFjdJ5CDzVw7gxtZpa9GWcoSrLoHx85WZ3gQ59xBVaHTM5pgfl+fED5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndakduNECvlXvwsXG+bMQPlVgAxjZl6OHanQU83MD3w=;
 b=VIuQO+g0PndFaRVt9W5Ij2+Vik0RVgd9ESLnoG96NSTtTEhgKaBsItHOoRptifH8t19hv5MJsVlIKA0Lm4wKY6WYfntSpeNV5kN3WkVz/FRvPOzkq81knbZ1dTJL7pEvt/ZxJmS7bm7mCFdQjC7GccbP5pymMfu0fEvoEUjjVCU=
Authentication-Results: freemail.hu; dkim=none (message not signed)
 header.d=none;freemail.hu; dmarc=none action=none header.from=oracle.com;
Subject: Re: two potential randstruct improvements
To: Jann Horn <jannh@google.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>
References: <CAG48ez1Mr1FNCDGFscVg0SpuuA_Z4tn=WJhEqJVWW1rOuRiG2w@mail.gmail.com>
From: Vegard Nossum <vegard.nossum@oracle.com>
Message-ID: <8d84f00e-9c99-c48b-8b7e-0b49d6b32390@oracle.com>
Date: Mon, 29 Mar 2021 12:16:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAG48ez1Mr1FNCDGFscVg0SpuuA_Z4tn=WJhEqJVWW1rOuRiG2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [86.217.245.67]
X-ClientProxiedBy: MR1P264CA0009.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::14) To CY4PR1001MB2133.namprd10.prod.outlook.com
 (2603:10b6:910:43::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8443041-8899-4d89-8c8f-08d8f29bc31b
X-MS-TrafficTypeDiagnostic: CY4PR10MB1622:
X-Microsoft-Antispam-PRVS: 
	<CY4PR10MB1622497EC99F246D04DC7F6C977E9@CY4PR10MB1622.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Lg5ZAi1b0y84katyI/Uc2cKG82PtQUyhKoom4uZJI6ixZUxKOThf/Ka9omABHn6O46Th+w4WZFvIC6gEJa+nXzqR6u29bKg5OZwtNRlaO21MNbj2GhaFFJD1Fh/807cWSFi+O2JAVy9YW2guMbtwKhiMneNqhYdtkbrvLcmypb3x0KcylJS2lExvwE7DnyIBCM8f7HFTo+oNMLSHjCSY7JajqeT1o+bB49jhOrAclXJpOTm93WAds13ojYH6eQ0sRLyqP6XaHgmCKFeDIVVXLQzpeHLPejs4GTNgsvw0USviNjavGftPVE6hTU+WSbZDscoy2rvt080+n5ziQq19+8vkz3AfiDtXZDHcKd04nh6a1orHgLZjelYSmPHJch/WVOO5HBvLSKC3DQ+jxUCr1x7iiEytHE4tBb1Snjy/LxSIc86pazn6GXKy3unekYMA3vaA5ULSpbYdwtM6HMCIdT/Z4w7KdRby67VWiw4896Ih0n31eUMHFUzye9mRtsmvNRhdQyXwuEm2pOgYcE1Cd9LSBXFBxFBcjpMOFKNNUaVA8XaUIXKaAtXwvMj5qBcXr4kfYOHUwzFt1KmH9MPXvHaFCoxTHqHmvbb2TAD7ZaLb2aZCM0uzXeThaYjsRBmSvHjbK85CMRb1E96p8c1fvppzy+B1Ijclu7DuOZoHq+OGTx03IF6pWsoMASpmdWtVR5mo4tVBpPC5IX1n2QJTbQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2133.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(396003)(346002)(376002)(31696002)(5660300002)(3480700007)(956004)(2616005)(31686004)(44832011)(6666004)(478600001)(66476007)(66946007)(316002)(16576012)(52116002)(38100700001)(53546011)(36756003)(6486002)(86362001)(8936002)(83380400001)(2906002)(110136005)(66556008)(186003)(16526019)(26005)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 
	=?utf-8?B?MDRqT1BNOURkRzV3dmoxYk0ySkFza093TVN0WjhTZEZONXVoTmgxQmJpNytT?=
 =?utf-8?B?cmtJK0xGZ1h2bHlXdlJjZk9BN1F6QUU3OG1MN1pPS0w2b2U1WTFValFXZkxV?=
 =?utf-8?B?WTk4MmUxTVNQWFVuWjU1aEdMaWMySC84U29IaWd3dHdHN0hiQTVTLzNjbHZj?=
 =?utf-8?B?SWNMSUFXSEhZMWVQbTFuUzRsYThNNDhRbHRwVGxUcVNMQUtsVnVacnpUOXpr?=
 =?utf-8?B?M3lNdHdBRnhuV29xSFBQeE9NeTF4L1pFc0ZSVUlUelpUdnZOaWZ1clZka1dr?=
 =?utf-8?B?cFFvbzZYNTNqRXVmSmdoQjZYVEE1TjBqV2F6U2hTc2JpVUNMcnNvRGF2dnI2?=
 =?utf-8?B?N1dXL0lDNzBtYzVPVko1b3NrR1Z0MHFveWYvSGd1VDNldWh0UVV0SnU2RzFa?=
 =?utf-8?B?NU4zbks4NEp2VjczMHR0T21BSmtTN1g4TElZS2RvYjFKeEp0TzVQNzJsWkFr?=
 =?utf-8?B?TE4ydFV3cG1VUi9BMG56UzhwcE90YzExMkptd0xSZjBLeitHZUdlblk1d0VO?=
 =?utf-8?B?Q2JnczFFd1lJcnZyd0xxc2cyUXpQVjFLeDE1M0p3K3pHWk5FaFN1N29wdDhL?=
 =?utf-8?B?d2FKNW9PRDJvaVluZnh0enNMYm9XbldleklySEVNcnltWDRSS0pGcFpIbnpF?=
 =?utf-8?B?WkZHV29CajVFVXhpVW84VHhQYU5FbGNWWVVuVnJ6NjFvaW5GaEwveWdCMStx?=
 =?utf-8?B?QmtVTGF4YUgzMytQNnlPVDdrWkNxdmU5VjcvVFV3N1J6T2NmUGdCZnhyWEFI?=
 =?utf-8?B?K05VeFhOaFZZdCtTejVrbllHN3YrTkVXZTBoNytCQmJFaXJEVkJhWkVyYTdz?=
 =?utf-8?B?Z05OQjRUeTFyL1g1ZWFxSW8vQ1lKenlZWDNPWjBRKzdiNXBmWDhVVFE3cko3?=
 =?utf-8?B?WXpzMHhOWm5GaTNKWkRwNjlYYlZBS0NWV3ZnQkY3QzNSaFNGOVR2ZU1ETGx0?=
 =?utf-8?B?U2JiV3ZpVm81bUhiL1pDd1Qra1BwQU1SRjBaN0MyUWlEYzJrTDVTSDlvYXBV?=
 =?utf-8?B?Y2ZXQUNscnVlcjJKVVNJZ1dzZGk5NUNXMGV0R09oL2lnOVR4ME9UeGVnQmta?=
 =?utf-8?B?YjZMRE9XZlB2RnZWZ1p2c3NJaTJRby83anlPU0xyNVFvSkRkb1RMN3ZlMW42?=
 =?utf-8?B?YUlrV0FzVHBlK0ErdWhsNkEyMjNoUEJsdmlUa3k5enBMTXF0NUlPZXVqVXdR?=
 =?utf-8?B?OVBTbU10T0s3Wkl3S0JUVkVuNy9EODN1N0dYeXdwTjVadzVGQklDbkFqU29E?=
 =?utf-8?B?K3hLRDNMMWJGOCtScWZxa2x6Nk5INGFGOEZNQjVuVTJpbndsVThlQmJOL3NL?=
 =?utf-8?B?Yi9aVExROG1Gcjl4eVZ5Vy9QUzBnQytxb2E0SWVWQlpFQThreU9OL0hmL2hG?=
 =?utf-8?B?MVNIa1ZFcytrSlYwWTlSVHEyTHlsRWxZOHcyeGxoaTRwendkMEV3Zk85Nm9r?=
 =?utf-8?B?RmRBekNvRU9RRmsvUktsZUVSaHVzZU5lZTVHV2l1Lzl4SVJ1TzNZcXZSRGEr?=
 =?utf-8?B?SmRacENJU2FDQnphUW15SS9mT0ZHZHBBTlFZTUxXMG9sa3JkN0o2aXZ3U045?=
 =?utf-8?B?eXZzMmlibUYrOStYeE5lL0F1c1JSVnQzVHdVV0Fkc2lpa0M4SWNpbWlsangx?=
 =?utf-8?B?L1NpWEVvalFJWm5nSFdlWmtQc3Z4TXlhKyt4TzhYQnBmMk9OaDFpTm1ubWJs?=
 =?utf-8?B?VDUycEhtbUY2R2JNQUF6Q3AzSDYvTWFtTFd2UlJQQ1BINXdqRWREVnVFQXZi?=
 =?utf-8?Q?WEvwndFY1aLQjvJh/R+08D68MD9ruHWbsZbDFwm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8443041-8899-4d89-8c8f-08d8f29bc31b
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2133.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 10:16:48.4008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUgLc31fcqpxouL9o0S/O/NRSkIgrO2P6wYCp+CRm6L3jPhqtj95xjctFP9FHhG+hg61cih6vPm1oaXwSFqfFEEMvJthzaQNfnb0XSrhtTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1622
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9937 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290079
X-Proofpoint-ORIG-GUID: q8nuWWcS3qaJ8OI3UWxd-B6VEu6Udqom
X-Proofpoint-GUID: q8nuWWcS3qaJ8OI3UWxd-B6VEu6Udqom
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9937 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1011 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290078


On 2021-03-29 09:26, Jann Horn wrote:
> Hi!
> 
> I'm currently in the middle of writing a blogpost on some Linux kernel
> stuff; while working on that I looked at the randstruct version in
> Linus' tree a bit and noticed two potential areas for improvement. I
> have no idea whether any of this (still) applies to the PaX/grsecurity
> version, but since the code originates from there, I figured I should
> also send this to the original authors.
> 
> 

[...]

> I don't know whether the amount of information leakage would be enough
> to actually determine the seed - and I'm not a cryptographer, I have
> no clue how much output from the RNG you'd actually need to recover
> the seed (and an attacker would not even be getting raw RNG output,
> but RNG output after additional modulo operations). But if the goal
> here is to ensure that an attacker without access to the binary kernel
> image can't determine struct layouts without a proper leak primitive,
> even if they know exactly from which sources and with what
> configuration the kernel was built, then I think this needs a
> cryptographically secure RNG.


Hi,

I just wanted to add something that stood out to me (assuming I'm 
reading the code correctly):

It looks like the per-struct seed is constructed only based on a hash of 
the struct name (using name_hash()), and anonymous structs use the name 
"anonymous", which means that anonymous structs with the same number of 
members will always be shuffled the same way (using full_shuffle() at 
least). Which means that you can gain information about one struct and 
potentially use it on another. It doesn't look like anonymous structs 
being randomized is very common, a quick run against kernel/fork.c shows 
there's only 3 cases and they all have different numbers of members (7, 
59, and 182). In any case, to mitigate this, maybe include some details 
of the struct (original member offsets/sizes/names) in the per-struct 
seed derivation?

I definitely second the recommendation to use cryptographically secure 
algorithms -- specifically, use a 256-bit HMAC that depends on the seed 
instead of name_hash() and a cryptographically secure PRNG for ranval().


Vegard
