Return-Path: <SRS0=pUyL=XE=lists.openwall.com=kernel-hardening-return-16883-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C1FC433EF
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Sep 2019 10:14:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7C89421479
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Sep 2019 10:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C89421479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16883-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20253 invoked by uid 550); 9 Sep 2019 10:14:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20233 invoked from network); 9 Sep 2019 10:14:05 -0000
Date: Mon, 9 Sep 2019 03:12:38 -0700 (PDT)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>
cc: Jeff Layton <jlayton@kernel.org>, Florian Weimer <fweimer@redhat.com>,
        =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@kernel.org>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Chiang <ericchiang@google.com>, Jan Kara <jack@suse.cz>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        =?ISO-8859-15?Q?Philippe_Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell <scottsh@microsoft.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shuah Khan <shuah@kernel.org>, Song Liu <songliubraving@fb.com>,
        Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
        Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
In-Reply-To: <49e98ece-e85f-3006-159b-2e04ba67019e@ssi.gouv.fr>
Message-ID: <alpine.LRH.2.21.1909090309260.27895@namei.org>
References: <20190906152455.22757-1-mic@digikod.net> <20190906152455.22757-2-mic@digikod.net> <87ef0te7v3.fsf@oldenburg2.str.redhat.com> <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr> <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
 <1fbf54f6-7597-3633-a76c-11c4b2481add@ssi.gouv.fr> <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org> <alpine.LRH.2.21.1909061202070.18660@namei.org> <49e98ece-e85f-3006-159b-2e04ba67019e@ssi.gouv.fr>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-912656596-1568023960=:27895"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-912656596-1568023960=:27895
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 9 Sep 2019, Mickaël Salaün wrote:

> 
> On 06/09/2019 21:03, James Morris wrote:
> > On Fri, 6 Sep 2019, Jeff Layton wrote:
> >
> >> The fact that open and openat didn't vet unknown flags is really a bug.
> >>
> >> Too late to fix it now, of course, and as Aleksa points out, we've
> >> worked around that in the past. Now though, we have a new openat2
> >> syscall on the horizon. There's little need to continue these sorts of
> >> hacks.
> >>
> >> New open flags really have no place in the old syscalls, IMO.
> >
> > Agree here. It's unfortunate but a reality and Linus will reject any such
> > changes which break existing userspace.
> 
> Do you mean that adding new flags to open(2) is not possible?
> 
> Does it means that unspecified behaviors are definitely part of the
> Linux specification and can't be fixed?

This is my understanding.

> 
> As I said, O_MAYEXEC should be ignored if it is not supported by the
> kernel, which perfectly fit with the current open(2) flags behavior, and
> should also behave the same with openat2(2).

The problem here is programs which are already using the value of 
O_MAYEXEC, which will break.  Hence, openat2(2).


-- 
James Morris
<jmorris@namei.org>

--1665246916-912656596-1568023960=:27895--
