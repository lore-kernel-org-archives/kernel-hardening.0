Return-Path: <SRS0=AimY=6P=lists.openwall.com=kernel-hardening-return-18692-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B3BC4724C
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 May 2020 04:03:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C98AA2073E
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 May 2020 04:03:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C98AA2073E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18692-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21853 invoked by uid 550); 1 May 2020 04:03:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21833 invoked from network); 1 May 2020 04:03:04 -0000
Date: Fri, 1 May 2020 14:02:16 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@kernel.org>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        Eric Chiang <ericchiang@google.com>,
        Florian Weimer <fweimer@redhat.com>, Jan Kara <jack@suse.cz>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
        Mimi Zohar <zohar@linux.ibm.com>,
        =?ISO-8859-15?Q?Philippe_Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell <scottsh@microsoft.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 2/5] fs: Add a MAY_EXECMOUNT flag to infer the noexec
 mount property
In-Reply-To: <20200428175129.634352-3-mic@digikod.net>
Message-ID: <alpine.LRH.2.21.2005011357290.29679@namei.org>
References: <20200428175129.634352-1-mic@digikod.net> <20200428175129.634352-3-mic@digikod.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="1665246916-2066436414-1588305635=:29679"
Content-ID: <alpine.LRH.2.21.2005011402110.29679@namei.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-2066436414-1588305635=:29679
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.21.2005011402111.29679@namei.org>

On Tue, 28 Apr 2020, Mickaël Salaün wrote:

> An LSM doesn't get path information related to an access request to open
> an inode.  This new (internal) MAY_EXECMOUNT flag enables an LSM to
> check if the underlying mount point of an inode is marked as executable.
> This is useful to implement a security policy taking advantage of the
> noexec mount option.
> 
> This flag is set according to path_noexec(), which checks if a mount
> point is mounted with MNT_NOEXEC or if the underlying superblock is
> SB_I_NOEXEC.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Reviewed-by: Philippe Trébuchet <philippe.trebuchet@ssi.gouv.fr>
> Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>

Are there any existing LSMs which plan to use this aspect?

-- 
James Morris
<jmorris@namei.org>
--1665246916-2066436414-1588305635=:29679--
