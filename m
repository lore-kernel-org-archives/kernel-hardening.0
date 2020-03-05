Return-Path: <SRS0=3dCW=4W=lists.openwall.com=kernel-hardening-return-18091-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85444C3F2D1
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 20:56:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E059E20801
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 20:56:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E059E20801
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18091-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31884 invoked by uid 550); 5 Mar 2020 20:56:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31847 invoked from network); 5 Mar 2020 20:56:38 -0000
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] sh: Stop printing the virtual memory layout
Date: Thu, 5 Mar 2020 21:56:15 +0100
Message-Id: <91C97773-5873-4336-9926-A013BB96B75C@physik.fu-berlin.de>
References: <20200305205158.GF6506@cisco>
Cc: Arvind Sankar <nivedita@alum.mit.edu>, Joe Perches <joe@perches.com>,
 Kees Cook <keescook@chromium.org>, "Tobin C . Harding" <me@tobin.cc>,
 kernel-hardening@lists.openwall.com,
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20200305205158.GF6506@cisco>
To: Tycho Andersen <tycho@tycho.ws>
X-Mailer: iPhone Mail (17D50)
X-Originating-IP: 80.187.119.22



> On Mar 5, 2020, at 9:52 PM, Tycho Andersen <tycho@tycho.ws> wrote:
>=20
> =EF=BB=BFOn Thu, Mar 05, 2020 at 10:56:29AM -0500, Arvind Sankar wrote:
>>> On Thu, Mar 05, 2020 at 04:49:22PM +0100, John Paul Adrian Glaubitz wrot=
e:
>>> On 3/5/20 4:46 PM, Arvind Sankar wrote:
>>>> Not really too late. I can do s/pr_info/pr_devel and resubmit.
>>>>=20
>>>> parisc for eg actually hides this in #if 0 rather than deleting the
>>>> code.
>>>>=20
>>>> Kees, you fine with that?
>>>=20
>>> But wasn't it removed for all the other architectures already? Or are th=
ese
>>> changes not in Linus' tree yet?
>>>=20
>>> Adrian
>>=20
>> The ones mentioned in the commit message, yes, those are long gone. But
>> I don't see any reason why the remaining ones (there are 6 left that I
>> submitted patches just now for) couldn't switch to pr_devel instead.
>=20
> If you do happen to re-send with pr_debug() instead, feel free to add
> my ack to that series as well.

Since it already got removed for most other architectures, I don=E2=80=99t t=
hink it makes much sense to keep it for consistency.

I just didn=E2=80=99t understand why it was made configurable for debugging p=
urposes in the first place.

Also, many distributions disable access to the kernel buffer for unprivilege=
d users anyway.

Adrian=

