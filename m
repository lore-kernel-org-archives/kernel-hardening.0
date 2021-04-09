Return-Path: <SRS0=fM1c=JG=lists.openwall.com=kernel-hardening-return-21189-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCB5C433ED
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Apr 2021 17:14:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ACD1D610F7
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Apr 2021 17:14:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACD1D610F7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21189-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1032 invoked by uid 550); 9 Apr 2021 17:14:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32756 invoked from network); 9 Apr 2021 17:14:20 -0000
Subject: Re: [PATCH v12 0/3] Add trusted_for(2) (was O_MAYEXEC)
To: bauen1 <j2468h@googlemail.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, casey@schaufler-ca.com,
 christian.brauner@ubuntu.com, christian@python.org, corbet@lwn.net,
 cyphar@cyphar.com, deven.desai@linux.microsoft.com, dvyukov@google.com,
 ebiggers@kernel.org, ericchiang@google.com, fweimer@redhat.com,
 geert@linux-m68k.org, jack@suse.cz, jannh@google.com, jmorris@namei.org,
 keescook@chromium.org, kernel-hardening@lists.openwall.com,
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
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <2a4cf50c-7e79-75d1-7907-8218e669f7fa@digikod.net>
Date: Fri, 9 Apr 2021 19:15:42 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <d3b0da18-d0f6-3f72-d3ab-6cf19acae6eb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit

Hi,

There was no new reviews, probably because the FS maintainers were busy,
and I was focused on Landlock (which is now in -next), but I plan to
send a new patch series for trusted_for(2) soon.

Thanks for letting know your interest,
 Mickaël


On 09/04/2021 18:26, bauen1 wrote:
> Hello,
> 
> As a user of SELinux I'm quite interested in the trusted_for / O_MAYEXEC changes in the kernel and userspace.
> However the last activity on this patch seems to be this email from 2020-12-03 with no replies, so what is the status of this patchset or is there something that I'm missing ?
> 
> https://patchwork.kernel.org/project/linux-security-module/list/?series=395617
> 
> https://lore.kernel.org/linux-security-module/20201203173118.379271-1-mic@digikod.net/
> 
> 
