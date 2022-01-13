Return-Path: <kernel-hardening-return-21536-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 691AAC433EF
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Jan 2022 22:00:36 +0000 (UTC)
Received: (qmail 16303 invoked by uid 550); 13 Jan 2022 22:00:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16283 invoked from network); 13 Jan 2022 22:00:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642111215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iYMosw5qYefWLA9YPdhAGhJH1W9UqqKjH99qcPpNMYc=;
	b=h29mTA8GIFWyec1jTO6aDD+sxMBDrmScJoXQxenT84OPoZVFv8F6JVUUAwOPfZyqv5J6n1
	B+eIi5EmG8VVrbWRDp6/la6fg/J14duCzFmYRdzLdfdWmyqoP4L87uStbbsmN2EgFU6TCo
	1gevrupn7ocOsCn6bGpLK6aG/kjDcBI=
X-MC-Unique: w9wVhzADN9q-FApepbjLOg-1
From: Florian Weimer <fweimer@redhat.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: linux-arch@vger.kernel.org,  Linux API <linux-api@vger.kernel.org>,
  linux-x86_64@vger.kernel.org,  kernel-hardening@lists.openwall.com,
  linux-mm@kvack.org,  the arch/x86 maintainers <x86@kernel.org>,
  musl@lists.openwall.com,  libc-alpha@sourceware.org,
  linux-kernel@vger.kernel.org,  Dave Hansen <dave.hansen@intel.com>,  Kees
 Cook <keescook@chromium.org>,  Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v3 2/3] selftests/x86/Makefile: Support per-target
 $(LIBS) configuration
References: <3a1c8280967b491bf6917a18fbff6c9b52e8df24.1641398395.git.fweimer@redhat.com>
	<54ae0e1f8928160c1c4120263ea21c8133aa3ec4.1641398395.git.fweimer@redhat.com>
	<034075bd-aac5-9b97-6d09-02d9dd658a0b@kernel.org>
Date: Thu, 13 Jan 2022 23:00:07 +0100
In-Reply-To: <034075bd-aac5-9b97-6d09-02d9dd658a0b@kernel.org> (Andy
	Lutomirski's message of "Thu, 13 Jan 2022 13:31:58 -0800")
Message-ID: <87lezjxpnc.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

* Andy Lutomirski:

> On 1/5/22 08:03, Florian Weimer wrote:
>> And avoid compiling PCHs by accident.
>> 
>
> The patch seems fine, but I can't make heads or tails of the
> $SUBJECT. Can you help me?

What about this?

selftests/x86/Makefile: Set linked libraries using $(LIBS)

I guess that it's possible to use make features to set this per target
isn't important.

Thanks,
Florian

>> Signed-off-by: Florian Weimer <fweimer@redhat.com>
>> ---
>> v3: Patch split out.
>>   tools/testing/selftests/x86/Makefile | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>> diff --git a/tools/testing/selftests/x86/Makefile
>> b/tools/testing/selftests/x86/Makefile
>> index 8a1f62ab3c8e..0993d12f2c38 100644
>> --- a/tools/testing/selftests/x86/Makefile
>> +++ b/tools/testing/selftests/x86/Makefile
>> @@ -72,10 +72,12 @@ all_64: $(BINARIES_64)
>>   EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
>>     $(BINARIES_32): $(OUTPUT)/%_32: %.c helpers.h
>> -	$(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm
>> +	$(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h, $^) \
>> +		$(or $(LIBS), -lrt -ldl -lm)
>>     $(BINARIES_64): $(OUTPUT)/%_64: %.c helpers.h
>> -	$(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
>> +	$(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h, $^) \
>> +		$(or $(LIBS), -lrt -ldl -lm)
>>     # x86_64 users should be encouraged to install 32-bit libraries
>>   ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)

