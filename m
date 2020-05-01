Return-Path: <SRS0=NMgR=6P=lists.openwall.com=kernel-hardening-return-18694-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A9CC47256
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 May 2020 04:23:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3699E20836
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 May 2020 04:23:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3699E20836
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18694-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10007 invoked by uid 550); 1 May 2020 04:23:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9984 invoked from network); 1 May 2020 04:23:13 -0000
Date: Fri, 1 May 2020 14:22:29 +1000 (AEST)
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
Subject: Re: [PATCH v3 3/5] fs: Enable to enforce noexec mounts or file exec
 through RESOLVE_MAYEXEC
In-Reply-To: <20200428175129.634352-4-mic@digikod.net>
Message-ID: <alpine.LRH.2.21.2005011409570.29679@namei.org>
References: <20200428175129.634352-1-mic@digikod.net> <20200428175129.634352-4-mic@digikod.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="1665246916-573384471-1588306338=:29679"
Content-ID: <alpine.LRH.2.21.2005011412230.29679@namei.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-573384471-1588306338=:29679
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.21.2005011412231.29679@namei.org>

On Tue, 28 Apr 2020, Mickaël Salaün wrote:

> Enable to either propagate the mount options from the underlying VFS
> mount to prevent execution, or to propagate the file execute permission.
> This may allow a script interpreter to check execution permissions
> before reading commands from a file.

I'm finding the description of this patch difficult to understand.

In the first case, this seems to mean: if you open a file with 
RESOLVE_MAYEXEC from a noexec mount, then it will fail. Correct?

In the second case, do you mean a RESOLVE_MAYEXEC open will fail if the 
file does not have +x set for the user?


> The main goal is to be able to protect the kernel by restricting
> arbitrary syscalls that an attacker could perform with a crafted binary
> or certain script languages.

This sounds like the job of seccomp. Why is this part of MAYEXEC?

>  It also improves multilevel isolation
> by reducing the ability of an attacker to use side channels with
> specific code.  These restrictions can natively be enforced for ELF
> binaries (with the noexec mount option) but require this kernel
> extension to properly handle scripts (e.g., Python, Perl).

Again, not sure why you're talking about side channels and MAYEXEC and 
mount options. Are you more generally talking about being able to prevent 
execution of arbitrary script files included by an interpreter?

> Add a new sysctl fs.open_mayexec_enforce to control this behavior.
> Indeed, because of compatibility with installed systems, only the system
> administrator is able to check that this new enforcement is in line with
> the system mount points and file permissions.  A following patch adds
> documentation.

I don't like the idea of any of this feature set being configurable. 
RESOLVE_MAYEXEC as a new flag should have well-defined, stable semantics.


-- 
James Morris
<jmorris@namei.org>
--1665246916-573384471-1588306338=:29679--
