Return-Path: <SRS0=fl2d=O3=lists.openwall.com=kernel-hardening-return-21421-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8D2C433EF
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Oct 2021 18:29:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B92AE61040
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Oct 2021 18:29:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B92AE61040
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 11289 invoked by uid 550); 7 Oct 2021 18:29:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11269 invoked from network); 7 Oct 2021 18:29:11 -0000
Subject: Re: [PATCH v12 0/3] Add trusted_for(2) (was O_MAYEXEC)
To: Kees Cook <keescook@chromium.org>
Cc: bauen1 <j2468h@googlemail.com>, akpm@linux-foundation.org, arnd@arndb.de,
 casey@schaufler-ca.com, christian.brauner@ubuntu.com, christian@python.org,
 corbet@lwn.net, cyphar@cyphar.com, deven.desai@linux.microsoft.com,
 dvyukov@google.com, ebiggers@kernel.org, ericchiang@google.com,
 fweimer@redhat.com, geert@linux-m68k.org, jack@suse.cz, jannh@google.com,
 jmorris@namei.org, kernel-hardening@lists.openwall.com,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, luto@kernel.org,
 madvenka@linux.microsoft.com, mjg59@google.com, mszeredi@redhat.com,
 mtk.manpages@gmail.com, nramas@linux.microsoft.com,
 philippe.trebuchet@ssi.gouv.fr, scottsh@microsoft.com,
 sean.j.christopherson@intel.com, sgrubb@redhat.com, shuah@kernel.org,
 steve.dower@python.org, thibaut.sautereau@clip-os.org,
 vincent.strubel@ssi.gouv.fr, viro@zeniv.linux.org.uk, willy@infradead.org,
 zohar@linux.ibm.com
References: <20201203173118.379271-1-mic@digikod.net>
 <d3b0da18-d0f6-3f72-d3ab-6cf19acae6eb@gmail.com>
 <2a4cf50c-7e79-75d1-7907-8218e669f7fa@digikod.net>
 <202110061500.B8F821C@keescook>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <4c4bbd74-0599-fed5-0340-eff197bafeb1@digikod.net>
Date: Thu, 7 Oct 2021 20:29:31 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <202110061500.B8F821C@keescook>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 07/10/2021 00:03, Kees Cook wrote:
> On Fri, Apr 09, 2021 at 07:15:42PM +0200, Mickaël Salaün wrote:
>> There was no new reviews, probably because the FS maintainers were busy,
>> and I was focused on Landlock (which is now in -next), but I plan to
>> send a new patch series for trusted_for(2) soon.
> 
> Hi!
> 
> Did this ever happen? It looks like it's in good shape, and I think it's
> a nice building block for userspace to have. Are you able to rebase and
> re-send this?

I just sent it:
https://lore.kernel.org/all/20211007182321.872075-1-mic@digikod.net/

Some Signed-off-by would be appreciated. :)

> 
> I've tended to aim these things at akpm if Al gets busy. (And since
> you've had past review from Al, that should be hopefully sufficient.)
> 
> Thanks for chasing this!
> 
> -Kees
> 
