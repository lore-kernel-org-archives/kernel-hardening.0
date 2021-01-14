Return-Path: <SRS0=MnoR=GR=lists.openwall.com=kernel-hardening-return-20647-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0940C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Jan 2021 19:03:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 16BA023B31
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Jan 2021 19:03:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16BA023B31
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20647-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10036 invoked by uid 550); 14 Jan 2021 19:03:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10003 invoked from network); 14 Jan 2021 19:03:51 -0000
Subject: Re: [PATCH v26 00/12] Landlock LSM
To: Jann Horn <jannh@google.com>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arch <linux-arch@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 linux-security-module <linux-security-module@vger.kernel.org>,
 the arch/x86 maintainers <x86@kernel.org>
References: <20201209192839.1396820-1-mic@digikod.net>
 <CAG48ez3DE8xgr_etVGV5eNjH2CXXo9MR7jTcu+_LCkJUchLXcQ@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <92df89c9-3442-0761-224a-ab53bb917850@digikod.net>
Date: Thu, 14 Jan 2021 20:03:47 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez3DE8xgr_etVGV5eNjH2CXXo9MR7jTcu+_LCkJUchLXcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 14/01/2021 04:22, Jann Horn wrote:
> On Wed, Dec 9, 2020 at 8:28 PM Mickaël Salaün <mic@digikod.net> wrote:
>> This patch series adds new built-time checks, a new test, renames some
>> variables and functions to improve readability, and shift syscall
>> numbers to align with -next.
> 
> Sorry, I've finally gotten around to looking at v26 - I hadn't
> actually looked at v25 either yet. I think there's still one remaining
> small issue in the filesystem access logic, but I think that's very
> simple to fix, as long as we agree on what the expected semantics are.
> Otherwise it basically looks good, apart from some typos.
> 
> I think v27 will be the final version of this series. :) (And I'll try
> to actually look at that version much faster - I realize that waiting
> for code reviews this long sucks.)
> 

I'm improving the tests, especially with bind mounts and overlayfs
tests. The v27 will also contains a better documentation to clarify the
semantic and explain how these mounts are handled. Thanks!
