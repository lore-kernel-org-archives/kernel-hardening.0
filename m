Return-Path: <SRS0=qbol=A3=lists.openwall.com=kernel-hardening-return-19354-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC4AC433E4
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 15:22:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F37FA2063A
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 15:22:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F37FA2063A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19354-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9301 invoked by uid 550); 16 Jul 2020 15:22:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9281 invoked from network); 16 Jul 2020 15:22:46 -0000
Subject: Re: [PATCH v6 7/7] ima: add policy support for the new file open
 MAY_OPENEXEC flag
To: Randy Dunlap <rdunlap@infradead.org>, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
 Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-8-mic@digikod.net> <202007151339.283D7CD@keescook>
 <8df69733-0088-3e3c-9c3d-2610414cea2b@digikod.net>
 <61c05cb0-a956-3cc7-5dab-e11ebf0e95bf@infradead.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <639b1727-2d61-5c29-623f-87eaf5a66a03@digikod.net>
Date: Thu, 16 Jul 2020 17:22:26 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <61c05cb0-a956-3cc7-5dab-e11ebf0e95bf@infradead.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 16/07/2020 16:59, Randy Dunlap wrote:
> On 7/16/20 7:40 AM, Mickaël Salaün wrote:
>>
>> On 15/07/2020 22:40, Kees Cook wrote:
>>> On Tue, Jul 14, 2020 at 08:16:38PM +0200, Mickaël Salaün wrote:
>>>> From: Mimi Zohar <zohar@linux.ibm.com>
>>>>
>>>> The kernel has no way of differentiating between a file containing data
>>>> or code being opened by an interpreter.  The proposed O_MAYEXEC
>>>> openat2(2) flag bridges this gap by defining and enabling the
>>>> MAY_OPENEXEC flag.
>>>>
>>>> This patch adds IMA policy support for the new MAY_OPENEXEC flag.
>>>>
>>>> Example:
>>>> measure func=FILE_CHECK mask=^MAY_OPENEXEC
>>>> appraise func=FILE_CHECK appraise_type=imasig mask=^MAY_OPENEXEC
>>>>
>>>> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
>>>> Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
>>>> Acked-by: Mickaël Salaün <mic@digikod.net>
>>>
>>> (Process nit: if you're sending this on behalf of another author, then
>>> this should be Signed-off-by rather than Acked-by.)
>>
>> I'm not a co-author of this patch.
>>
> 
> from Documentation/process/submitting-patches.rst:
> 
> The Signed-off-by: tag indicates that the signer was involved in the
> development of the patch, or that he/she was in the patch's delivery path.
>                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 

OK, I though such tag had to go along with the From/Author, the
Committer or a Co-developed-by tag, but there is also this specific
case. I'll fix that in the next series.
