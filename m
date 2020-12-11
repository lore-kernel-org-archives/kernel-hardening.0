Return-Path: <SRS0=gasV=FP=lists.openwall.com=kernel-hardening-return-20579-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F699C4361B
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 09:33:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 15E3523F58
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 09:33:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15E3523F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20579-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5217 invoked by uid 550); 11 Dec 2020 09:33:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5182 invoked from network); 11 Dec 2020 09:33:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0NGlFtaX9S6HQB1ttjEbafzd+6rL5R7qxOmL92n3Uc=;
 b=fbhUDn2YCRFwiLJCSfwD74zcmx3LsbOah2lM0E6erSk74mNLEntA5FePyiFQGLoRwk9fIHJR5L8Qlcw44gn0HJNPOLxCh5vW7FXnlClRTzurQmJuYUAkKnt/ixvkIJjRstY9QhReM7E/9GPuoVcQ6TP5enM+QBLcpN6jICYAfLI=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: 4666d5f4ef21b8db
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLs95G+KjJxrAMh5WpzNdDHLjBsUHy2+SqF+clw8PbOZQr+u/YXBtkDfkBr8fa021xmNscSwJ1yEo01zJ9Hebupexmw0PDjENXJ81u4O7yNx/jU6oT3zKwN+rK7WDF8ipHRvbZdmRv8rPJCWFsIUefNThfuBqRoQD11d4H502GLXeoEetKGVp4JEOsOAwm8Kfm56sQu8RCBEkTIsVQEytwpK634EdiYRFIe4mNaxTZpGcfXIjbA6GnBwhp7icle/XPs4mNxIZL1yD1cvxACTXI9nKx7lQ6fzG1J/Ps5QeD5/53GHwRCR3uouwQzUcsHTyQgnaBlSS5F7a8Fb8NJ9Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0NGlFtaX9S6HQB1ttjEbafzd+6rL5R7qxOmL92n3Uc=;
 b=A4T/s0trw9rJagmRxHeOh56VvT4miv1wwTezQH5OcZYS+hKQsqPvMU/zXyV54wqKNhuHbfCvMkjf6bn5pKTE0LzdSwLyVNdqkWsP60uGakAiu+6u/TGM/DXDI19ALEuiWsNTjGr1USc1Fe2dCH7Pz22jap1IS1XPxKyE0vVz21tlkCstNVvDmxqFv4mzsjdMN+2GoAqmDQVbYUG49juEShZFM3r9NGmEXwGDaesmSXqIkZrICEYxljc27ErhB1BcC8hLN2Zkk2+s15lZ7im4UIUt3hWcHW2Xfl3oaClLLJgZZUb91BjscR7vxaL2Q1vaf+SxjEhUo+Qdk7/jTXwtMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0NGlFtaX9S6HQB1ttjEbafzd+6rL5R7qxOmL92n3Uc=;
 b=fbhUDn2YCRFwiLJCSfwD74zcmx3LsbOah2lM0E6erSk74mNLEntA5FePyiFQGLoRwk9fIHJR5L8Qlcw44gn0HJNPOLxCh5vW7FXnlClRTzurQmJuYUAkKnt/ixvkIJjRstY9QhReM7E/9GPuoVcQ6TP5enM+QBLcpN6jICYAfLI=
Authentication-Results-Original: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=arm.com;
Date: Fri, 11 Dec 2020 09:32:56 +0000
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: libc-alpha@sourceware.org, Mark Rutland <mark.rutland@arm.com>,
	kernel-hardening@lists.openwall.com,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Topi Miettinen <toiwoton@gmail.com>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/6] elf: Fix failure handling in
 _dl_map_object_from_fd
Message-ID: <20201211093255.GD24625@arm.com>
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
 <8ebf571196dd499c61983dbf53c94c68ebd458cc.1606319495.git.szabolcs.nagy@arm.com>
 <1525639f-560f-2677-b1cb-f904b3552c71@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1525639f-560f-2677-b1cb-f904b3552c71@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: DM6PR11CA0013.namprd11.prod.outlook.com
 (2603:10b6:5:190::26) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b5e08f94-c710-4f9e-61a4-08d89db7cd9e
X-MS-TrafficTypeDiagnostic: PR3PR08MB5851:|HE1PR0802MB2363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<HE1PR0802MB23631DC07F29E67DB07B661AEDCA0@HE1PR0802MB2363.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 SJELLdooa0Sa6urSNkHQ6cEYJuYQ9FmWUm8q8lq/BIRFWmqjP5BgNwRMbRMEbF57RNTH7tdc8Qg7kDKmvLyv782SdEhyEnVoCWgAuW5BrCxTfvIDkWmo+uFzKmx6uBoxNxLcOAAfqmU85qfyePKPq5wjw0T1ZjHalYMIlIuhMidt27yqQkpTmxKrFSql4WsWNk4DqCrNo1H/KP2SILczDPPnTmkhbqDEIrmCBDSk3U9FpkaAMmbRA39Bkedz3IDiHqfG86hFHsS6iZ3fM+DVUm7GMU7Yi3KB3AHlxixQ/BSH1KGJJyu3WoRlR042NQrG
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39850400004)(366004)(2906002)(186003)(4326008)(36756003)(33656002)(7696005)(956004)(8676002)(26005)(52116002)(66946007)(53546011)(66476007)(86362001)(8886007)(66556008)(8936002)(55016002)(2616005)(6916009)(16526019)(478600001)(6666004)(316002)(1076003)(44832011)(5660300002)(83380400001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 =?utf-8?B?RmJCU1FqUUthVlhGWjBJZ29rRzcwNlluRm5oemtXVjRpYko1NWRESTFnenV6?=
 =?utf-8?B?V0lnNi94eENrdzZjN2xza0l1RVNwZ3I4NmYySkpYNnlCWGltbWNVYnBGeWtC?=
 =?utf-8?B?Mld0ZlJpNjBESVJVR3RScGFLaTVWVkNQb0lTWFhNR0NDMm9McjdFZ0tzaXg0?=
 =?utf-8?B?dmpEOHp4WnNQV2o2L2RmMkRUMnM5RFp1ZGlUUHlmOU1UYkdTSUwxNXR4a1Y1?=
 =?utf-8?B?TS9LKzVrbkl0WWEzMm9YUTVPNHZYV0pZa1AxbVdsOFphL1NKZnhDc0FtUWNl?=
 =?utf-8?B?U21nMUd5YzFRTGJVNHJlb3lFMkZ4SXN0RWl3VlpkUzdZdWQ0UElvaWNTRitH?=
 =?utf-8?B?YnR0TlowQ1U0UXhZOU9pM2JWRy9ubDhNYjk5elRYQ3VOeGUzWTBnODltWDZO?=
 =?utf-8?B?SG5peG5iSWhZTDlpK1AwWjJEUEkyYUFJQnZWYjd1UFJhaTJXbWNoc2Z2RFZn?=
 =?utf-8?B?QTNpM2syTHhyQ0ZyU0NFQU4xZFF2VkQrdlJjZ1FzUXlBR1NpS0txMklZL1pG?=
 =?utf-8?B?eTIwQWZWbVJVY1VwdTJTSDZpckxLNW5LY25SeG9LRWtyMjVES2krdnZZTmhI?=
 =?utf-8?B?b1BiZmJxejU0NVNzdnpNTlFNdk0xL2FxVk9jNEExdEQ1dkZ4NWhtOC8yRWtM?=
 =?utf-8?B?V1FNcGhMMnR1RGdKZDhUUnlxM2NPT2taRkMzZGp5ajQ0bDdUL3JiWDBVbVla?=
 =?utf-8?B?MmtsWk9MNTFmNlJ6aDJVUHJiZ2VpZ2tta3lWQ3crVFlvQVNvTnR6MEEzNGpF?=
 =?utf-8?B?N21oWUpibDdPbS90RzNFZnpRWU5oM2tGOXMza1oxL0dTWlIycHdEUEIxaUdp?=
 =?utf-8?B?MHhGVHJzWlQrbXhnZGZLTkFDWnBhekFpQ0xMSld2T28wc2xSbUFvS1pKUzRE?=
 =?utf-8?B?N3VKbEh5a250UTRZOGJWVnpzOEZCZ1F3dXdqVHB4dzJJeWViUlI0emY2ZXFT?=
 =?utf-8?B?RU5ybDcvOHBJOEFObzB3cXdobG9rMDRmZ0g0Ni9taGtyT3I5L3RmM3Y2U0RZ?=
 =?utf-8?B?eGdjdXc3VEZlV1Z3S3VQdnVjejNhMnhXcGpERFJDSzZFZC9QYjBtaW1JYitT?=
 =?utf-8?B?ZnFMbXduUWdrazBGd25qcG8zb0dwaXBtQ2ZGbmRHNXRkcFh1MmVFREhLMDhJ?=
 =?utf-8?B?Zjh5d0NFU2l2ZVNCMTd5aWowNGdYbW94bUVxQmFFaXlqYWVkcVBvaldQdk92?=
 =?utf-8?B?d2tGZGx1QjA0Q2xBYmVKZjFtT2ZiNEFZdzhWeGRRR01WVjJnL2FxWStxVk5U?=
 =?utf-8?B?VnVmS0xNN0hONVV5VlBEek5ic3VwMG0yRitPU0ZKMFNxTU81cmtsTlpSTVo0?=
 =?utf-8?Q?AeI91gr6Brg18YwqAH+IPZi7krKzlgmL/a?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5851
Original-Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5EUR03FT034.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8f637007-6c6a-4eb5-6bc6-08d89db7c3b4
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4M85dj0utKvpYmWcmkRl2UFVeEZ18ny0ZW9ukGrDXMQEKO97Mx9EWHwFNjl8D/OJYBe00obRNA1GGkphAXwvoyQ9A4EsiklbcRnyvS/XrPqhVIxQRFoYBcgL7JxnGQlEChTqKhstAkX+hkBMT06ZsZSHIurXnZSnnalhdr4AkCRXFzNL6g1pPhv/71aDaeRmOvgpYXy5lxmgWM0ssvNqUySUxQrEkBKbFsI55kMgBwBm4uR/1ZbwHvn2MUCjzYnqsh3AWzjZVUpo8p8l/dJed8AP/lMkh1wc3jljZOnDUcTUIg2aJ6Ce3N6Va6yprdRFBFnzXDUXFY4XXpzhVIIbzln2iTkYd37GWwqWx5+9Z5B+En6BcHx+PQWBSNw0KBdK0MLkqffVP/sOYlXwjhEx/g==
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39850400004)(396003)(136003)(46966005)(82310400003)(70586007)(1076003)(36756003)(6666004)(26005)(107886003)(55016002)(478600001)(2616005)(956004)(6862004)(316002)(44832011)(7696005)(4326008)(336012)(2906002)(356005)(33656002)(54906003)(81166007)(53546011)(82740400003)(8676002)(186003)(5660300002)(47076004)(86362001)(8936002)(83380400001)(16526019)(8886007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 09:33:22.7140
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e08f94-c710-4f9e-61a4-08d89db7cd9e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5EUR03FT034.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2363

The 12/10/2020 15:25, Adhemerval Zanella wrote:
> On 27/11/2020 10:20, Szabolcs Nagy via Libc-alpha wrote:
> > There are many failure paths that call lose to do local cleanups
> > in _dl_map_object_from_fd, but it did not clean everything.
> > 
> > Handle l_phdr, l_libname and mapped segments in the common failure
> > handling code.
> > 
> > There are various bits that may not be cleaned properly on failure
> > (e.g. executable stack, tlsid, incomplete dl_map_segments).
> > ---
> >  elf/dl-load.c | 24 +++++++++++++++---------
> >  1 file changed, 15 insertions(+), 9 deletions(-)
> > 
> > diff --git a/elf/dl-load.c b/elf/dl-load.c
> > index 21e55deb19..9c71b7562c 100644
> > --- a/elf/dl-load.c
> > +++ b/elf/dl-load.c
> > @@ -914,8 +914,15 @@ lose (int code, int fd, const char *name, char *realname, struct link_map *l,
> >    /* The file might already be closed.  */
> >    if (fd != -1)
> >      (void) __close_nocancel (fd);
> > +  if (l != NULL && l->l_map_start != 0)
> > +    _dl_unmap_segments (l);
> >    if (l != NULL && l->l_origin != (char *) -1l)
> >      free ((char *) l->l_origin);
> > +  if (l != NULL && !l->l_libname->dont_free)
> > +    free (l->l_libname);
> > +  if (l != NULL && l->l_phdr_allocated)
> > +    free ((void *) l->l_phdr);
> > +
> >    free (l);
> >    free (realname);
> >  
> > @@ -1256,7 +1263,11 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
> >      errstring = _dl_map_segments (l, fd, header, type, loadcmds, nloadcmds,
> >  				  maplength, has_holes, loader);
> >      if (__glibc_unlikely (errstring != NULL))
> > -      goto call_lose;
> > +      {
> > +	/* Mappings can be in an inconsistent state: avoid unmap.  */
> > +	l->l_map_start = l->l_map_end = 0;
> > +	goto call_lose;
> > +      }
> >  
> >      /* Process program headers again after load segments are mapped in
> >         case processing requires accessing those segments.  Scan program
> 
> In this case I am failing to see who would be responsible to unmap 
> l_map_start int the type == ET_DYN where first mmap succeeds but
> with a later mmap failure in any load command.

failures are either cleaned up locally in this function
via lose or after a clean return via dlclose.

failures that are not cleaned up will leak resources.

_dl_map_segments failure is not cleaned up (the mappings
are in an unknown state). however after a successful
_dl_map_segments later failures can clean the mappings
and that's what i fixed here.

i did not try to fix transitive design bugs (such as
leaks in _dl_map_segments) that would require interface
change or local cleanups in those other functions.

> > @@ -1294,14 +1305,6 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
> >        || (__glibc_unlikely (l->l_flags_1 & DF_1_PIE)
> >  	  && __glibc_unlikely ((mode & __RTLD_OPENEXEC) == 0)))
> >      {
> > -      /* We are not supposed to load this object.  Free all resources.  */
> > -      _dl_unmap_segments (l);
> > -
> > -      if (!l->l_libname->dont_free)
> > -	free (l->l_libname);
> > -
> > -      if (l->l_phdr_allocated)
> > -	free ((void *) l->l_phdr);
> >  
> >        if (l->l_flags_1 & DF_1_PIE)
> >  	errstring
> > @@ -1392,6 +1395,9 @@ cannot enable executable stack as shared object requires");
> >    /* Signal that we closed the file.  */
> >    fd = -1;
> >  
> > +  /* Failures before this point are handled locally via lose.
> > +     No more failures are allowed in this function until return.  */
> > +
> >    /* If this is ET_EXEC, we should have loaded it as lt_executable.  */
> >    assert (type != ET_EXEC || l->l_type == lt_executable);
> >  
> > 
> 
> Ok.
