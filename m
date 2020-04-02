Return-Path: <SRS0=DP1G=5S=lists.openwall.com=kernel-hardening-return-18394-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E105C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 17:07:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7716F206F6
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 17:07:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7716F206F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18394-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17639 invoked by uid 550); 2 Apr 2020 17:07:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17617 invoked from network); 2 Apr 2020 17:07:45 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexander Viro <viro@zeniv.linux.org.uk>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>,  David Howells <dhowells@redhat.com>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
	<20200327172331.418878-9-gladkov.alexey@gmail.com>
	<87d08pkh4u.fsf@x220.int.ebiederm.org>
	<20200402165156.4mzenof4upvtd3lv@comp-core-i7-2640m-0182e6>
Date: Thu, 02 Apr 2020 12:04:44 -0500
In-Reply-To: <20200402165156.4mzenof4upvtd3lv@comp-core-i7-2640m-0182e6>
	(Alexey Gladkov's message of "Thu, 2 Apr 2020 18:51:56 +0200")
Message-ID: <87r1x5iztf.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-XM-SPF: eid=1jK3JQ-0007EN-Ov;;;mid=<87r1x5iztf.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19JB6md/ag4gch1HCHlHqnPcaDKiSdq078=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v10 8/9] proc: use human-readable values for hidehid
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> On Thu, Apr 02, 2020 at 11:05:21AM -0500, Eric W. Biederman wrote:
>> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
>>=20
>> > The hidepid parameter values are becoming more and more and it becomes
>> > difficult to remember what each new magic number means.
>>=20
>> In principle I like this change.  In practice I think you have just
>> broken ABI compatiblity with the new mount ABI.
>>=20
>> In particular the following line seems broken.
>>=20
>> > diff --git a/fs/proc/root.c b/fs/proc/root.c
>> > index dbcd96f07c7a..ba782d6e6197 100644
>> > --- a/fs/proc/root.c
>> > +++ b/fs/proc/root.c
>> > @@ -45,7 +45,7 @@ enum proc_param {
>> >=20=20
>> >  static const struct fs_parameter_spec proc_fs_parameters[] =3D {
>> >  	fsparam_u32("gid",	Opt_gid),
>> > -	fsparam_u32("hidepid",	Opt_hidepid),
>> > +	fsparam_string("hidepid",	Opt_hidepid),
>> >  	fsparam_string("subset",	Opt_subset),
>> >  	{}
>> >  };
>>=20
>> As I read fs_parser.c fs_param_is_u32 handles string inputs and turns th=
em
>> into numbers, and it handles binary numbers.  However fs_param_is_string
>> appears to only handle strings.  It appears to have not capacity to turn
>> raw binary numbers into strings.
>
> I use result only with hidepid_u32_spec and nobody modifies param->string.
> I do not use internal functions here.
>
> I don=E2=80=99t follow how a raw number can get here ?

I may be wrong but last I looked you can input raw numbers using the new
mount api.   I have most of the details paged out at the moment,
but I believe that is why when you set a parameter in the new mount api
it takes a type.

>> So I think we probably need to fix fs_param_is_string to raw binary
>> numbers before we can safely make this change to fs/proc/root.c
>>=20
>> David am I reading the fs_parser.c code correctly?  If I am are you ok
>> with a change like the above?

Eric
