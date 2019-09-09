Return-Path: <SRS0=RjrO=XE=lists.openwall.com=kernel-hardening-return-16881-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAF5C00307
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Sep 2019 09:25:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E7BA42196E
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Sep 2019 09:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ssi.gouv.fr header.i=@ssi.gouv.fr header.b="cEmdP5ov"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7BA42196E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ssi.gouv.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16881-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5619 invoked by uid 550); 9 Sep 2019 09:25:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5586 invoked from network); 9 Sep 2019 09:25:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ssi.gouv.fr;
	s=20160407; t=1568021108;
	bh=N+IZDi6EMc1UHeYqtJi66wNIX1rNqIqEM1dZBIri2wY=;
	h=Subject:To:CC:References:From:Date:In-Reply-To:From:Subject;
	b=cEmdP5ovBbue513rWsTtXTEg7jbCJ0iKcxIZ+d2TdibRxaBTwn8/mNe+539HVG5O1
	 oX3Ezo17c1XnP+hL5GgutTFMlFBh+zFbrQEBhBdP/sqjXQEHLsrCQ6l0trj1K+aqIl
	 vWZPncZyAjnzxLR6zDgQNOS2f4LH9N999DDeZBK2MiWv+GRj4SiixnAjCvrCEynij2
	 H57NrV22jXYpf7rV77Gg2pSArNkomq/DErRl4YYtqyUIOAaso+suqFDp+Zot562x7f
	 uO92pZn3KcMdwA6pJ8EPNA3mcZXkMuC5KBUA3M1gyxfkBi8RfCUVlnaVS5o1f7LuAg
	 6UBwoSdAVVjGw==
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
To: James Morris <jmorris@namei.org>, Jeff Layton <jlayton@kernel.org>
CC: Florian Weimer <fweimer@redhat.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?=
	<mic@digikod.net>, <linux-kernel@vger.kernel.org>, Aleksa Sarai
	<cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro
	<viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian
 Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric
 Chiang <ericchiang@google.com>, Jan Kara <jack@suse.cz>, Jann Horn
	<jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook
	<keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox
	<willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar
	<zohar@linux.ibm.com>, =?UTF-8?Q?Philippe_Tr=c3=a9buchet?=
	<philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, Sean
 Christopherson <sean.j.christopherson@intel.com>, Shuah Khan
	<shuah@kernel.org>, Song Liu <songliubraving@fb.com>, Steve Dower
	<steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, Thibaut Sautereau
	<thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel
	<vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez
	<yves-alexis.perez@ssi.gouv.fr>, <kernel-hardening@lists.openwall.com>,
	<linux-api@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
References: <20190906152455.22757-1-mic@digikod.net>
 <20190906152455.22757-2-mic@digikod.net>
 <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
 <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
 <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
 <1fbf54f6-7597-3633-a76c-11c4b2481add@ssi.gouv.fr>
 <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org>
 <alpine.LRH.2.21.1909061202070.18660@namei.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Message-ID: <49e98ece-e85f-3006-159b-2e04ba67019e@ssi.gouv.fr>
Date: Mon, 9 Sep 2019 11:25:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:52.0) Gecko/20100101
 Thunderbird/52.9.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.1909061202070.18660@namei.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 06/09/2019 21:03, James Morris wrote:
> On Fri, 6 Sep 2019, Jeff Layton wrote:
>
>> The fact that open and openat didn't vet unknown flags is really a bug.
>>
>> Too late to fix it now, of course, and as Aleksa points out, we've
>> worked around that in the past. Now though, we have a new openat2
>> syscall on the horizon. There's little need to continue these sorts of
>> hacks.
>>
>> New open flags really have no place in the old syscalls, IMO.
>
> Agree here. It's unfortunate but a reality and Linus will reject any such
> changes which break existing userspace.

Do you mean that adding new flags to open(2) is not possible?

Does it means that unspecified behaviors are definitely part of the
Linux specification and can't be fixed?

As I said, O_MAYEXEC should be ignored if it is not supported by the
kernel, which perfectly fit with the current open(2) flags behavior, and
should also behave the same with openat2(2).


--
Micka=C3=ABl Sala=C3=BCn

Les donn=C3=A9es =C3=A0 caract=C3=A8re personnel recueillies et trait=C3=A9=
es dans le cadre de cet =C3=A9change, le sont =C3=A0 seule fin d=E2=80=99ex=
=C3=A9cution d=E2=80=99une relation professionnelle et s=E2=80=99op=C3=A8re=
nt dans cette seule finalit=C3=A9 et pour la dur=C3=A9e n=C3=A9cessaire =C3=
=A0 cette relation. Si vous souhaitez faire usage de vos droits de consulta=
tion, de rectification et de suppression de vos donn=C3=A9es, veuillez cont=
acter contact.rgpd@sgdsn.gouv.fr. Si vous avez re=C3=A7u ce message par err=
eur, nous vous remercions d=E2=80=99en informer l=E2=80=99exp=C3=A9diteur e=
t de d=C3=A9truire le message. The personal data collected and processed du=
ring this exchange aims solely at completing a business relationship and is=
 limited to the necessary duration of that relationship. If you wish to use=
 your rights of consultation, rectification and deletion of your data, plea=
se contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message i=
n error, we thank you for informing the sender and destroying the message.
