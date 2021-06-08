Return-Path: <SRS0=GGvM=LC=lists.openwall.com=kernel-hardening-return-21294-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2158C47082
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Jun 2021 23:38:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ECCFA61185
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Jun 2021 23:38:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECCFA61185
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21294-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28236 invoked by uid 550); 8 Jun 2021 23:38:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28216 invoked from network); 8 Jun 2021 23:38:29 -0000
IronPort-SDR: PlxwlQv+pS4LHxTc8XbaBUAlasHVc2qKrEQ+8Zqsxx/pjShEUDI2Ol+qicGjga2SwH8aY8fsGL
 jRbNiOV2Q6Bg==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="290595554"
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; 
   d="scan'208";a="290595554"
IronPort-SDR: pE4bdvjF0J9Yr2v3Y5b0EYAhXyF61Gs96zOXtSka7ND8veuaNykb0Auifm2a4kdYM6xKQUkwk/
 irwRg3JJ0msA==
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; 
   d="scan'208";a="551784529"
Subject: Re: [PATCH v8 0/8] Fork brute force attack mitigation
To: Kees Cook <keescook@chromium.org>, John Wood <john.wood@gmx.com>
Cc: Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Arnd Bergmann <arnd@arndb.de>, valdis.kletnieks@vt.edu,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com
References: <20210605150405.6936-1-john.wood@gmx.com>
 <202106081616.EC17DC1D0D@keescook>
From: Andi Kleen <ak@linux.intel.com>
Message-ID: <cbfd306b-6e37-a697-ebdb-4a5029d36583@linux.intel.com>
Date: Tue, 8 Jun 2021 16:38:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <202106081616.EC17DC1D0D@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US


On 6/8/2021 4:19 PM, Kees Cook wrote:
> On Sat, Jun 05, 2021 at 05:03:57PM +0200, John Wood wrote:
>> [...]
>> the kselftest to avoid the detection ;) ). So, in this version, to track
>> all the statistical data (info related with application crashes), the
>> extended attributes feature for the executable files are used. The xattr is
>> also used to mark the executables as "not allowed" when an attack is
>> detected. Then, the execve system call rely on this flag to avoid following
>> executions of this file.
> I have some concerns about this being actually usable and not creating
> DoS situations. For example, let's say an attacker had found a hard-to-hit
> bug in "sudo", and starts brute forcing it. When the brute LSM notices,
> it'll make "sudo" unusable for the entire system, yes?
>
> And a reboot won't fix it, either, IIUC.
>
The whole point of the mitigation is to trade potential attacks against DOS.

If you're worried about DOS the whole thing is not for you.

-Andi



