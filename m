Return-Path: <kernel-hardening-return-21563-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 15D01C433EF
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jun 2022 20:46:41 +0000 (UTC)
Received: (qmail 22503 invoked by uid 550); 1 Jun 2022 20:46:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25730 invoked from network); 1 Jun 2022 19:03:44 -0000
Message-ID: <56be248f-9063-1322-7b1e-83bc59414be8@leventepolyak.net>
Date: Wed, 1 Jun 2022 21:03:11 +0200
MIME-Version: 1.0
User-Agent: Mutt/2.1.42 (2034-12-24)
Content-Language: en-US
To: Yann Droneaud <ydroneaud@opteya.com>,
 Simon Brand <simon.brand@postadigitale.de>, kernelnewbies@kernelnewbies.org,
 linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com
References: <Yoy9IqTvch7lBwdT@hostpad>
 <fd5cf4a3-ba98-5c98-f823-e83f58a1d40c@opteya.com>
From: Levente Polyak <levente@leventepolyak.net>
Subject: Re: Possibility of merge of disable icotl TIOCSTI patch
In-Reply-To: <fd5cf4a3-ba98-5c98-f823-e83f58a1d40c@opteya.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;levente@leventepolyak.net;1654110224;ab58651b;
X-HE-SMSGID: 1nwTcx-0002EG-6D

On 6/1/22 17:41, Yann Droneaud wrote:
>> I would provide a patch which leaves the current behavior as default,
>> but TIOCSTI can be disabled via Kconfig or cmdline switch.
>> Is there any chance this will get merged in 2022, since past
>> attempts failed?
>>

Small side note:

A complete version of Matt's initial patch has lived on in 
linux-hardened [0][1] with the `SECURITY_TIOCSTI_RESTRICT` Kconfig 
(default no) and a `tiocsti_restrict` sysctl.

If a re-attempt is feasible, both patchs [0][1] could potentially be 
re-proposed as is.

In linux-hardened we have an independent patch [2] which simply sets the 
default value of `SECURITY_TIOCSTI_RESTRICT` to `yes`, but that most 
likely is not desired.

cheers,
Levente


[0] 
https://github.com/anthraxx/linux-hardened/commit/d0e49deb1a39dc64e7c7db3340579cfc9ab1e0df
[1] 
https://github.com/anthraxx/linux-hardened/commit/ea8f20602a993c90125bf08da39894f01166dc73
[2] 
https://github.com/anthraxx/linux-hardened/commit/238551f7b6a138d6f9ba0d55fe70cf6ddc237f47
