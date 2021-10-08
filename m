Return-Path: <SRS0=1J3Z=O4=lists.openwall.com=kernel-hardening-return-21428-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361BEC433EF
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 Oct 2021 10:20:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5542960FA0
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 Oct 2021 10:20:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5542960FA0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 7219 invoked by uid 550); 8 Oct 2021 10:20:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7194 invoked from network); 8 Oct 2021 10:20:49 -0000
Subject: Re: [PATCH v13 3/3] selftest/interpreter: Add tests for
 trusted_for(2) policies
To: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>,
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jmorris@namei.org>,
 Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Paul Moore <paul@paul-moore.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
 Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20211007182321.872075-1-mic@digikod.net>
 <20211007182321.872075-4-mic@digikod.net> <202110071227.669B5A91C@keescook>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <b1599775-a061-6c91-03a4-c82734c7f58c@digikod.net>
Date: Fri, 8 Oct 2021 12:21:12 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <202110071227.669B5A91C@keescook>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 07/10/2021 21:48, Kees Cook wrote:
> On Thu, Oct 07, 2021 at 08:23:20PM +0200, Mickaël Salaün wrote:

[...]

>> diff --git a/tools/testing/selftests/interpreter/Makefile b/tools/testing/selftests/interpreter/Makefile
>> new file mode 100644
>> index 000000000000..1f71a161d40b
>> --- /dev/null
>> +++ b/tools/testing/selftests/interpreter/Makefile
>> @@ -0,0 +1,21 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +
>> +CFLAGS += -Wall -O2
>> +LDLIBS += -lcap
>> +
>> +src_test := $(wildcard *_test.c)
>> +TEST_GEN_PROGS := $(src_test:.c=)
>> +
>> +KSFT_KHDR_INSTALL := 1
>> +include ../lib.mk
>> +
>> +khdr_dir = $(top_srcdir)/usr/include
>> +
>> +$(khdr_dir)/asm-generic/unistd.h: khdr
>> +	@:
>> +
>> +$(khdr_dir)/linux/trusted-for.h: khdr
>> +	@:
>> +
>> +$(OUTPUT)/%_test: %_test.c $(khdr_dir)/asm-generic/unistd.h $(khdr_dir)/linux/trusted-for.h ../kselftest_harness.h
>> +	$(LINK.c) $< $(LDLIBS) -o $@ -I$(khdr_dir)
> 
> Is all this really needed?

Yes, all this is needed to be sure that the tests will be rebuild when a
dependency change (either one of the header files or a source file).

> 
> - CFLAGS and LDLIBS will be used by the default rules

Yes, but it will only run the build command when a source file change,
not a header file.

> - khdr is already a pre-dependency when KSFT_KHDR_INSTALL is set

Yes, but it is not enough to rebuild the tests (and check the installed
files) when a header file change.

> - kselftest_harness.h is already a build-dep (see LOCAL_HDRS)

Yes, but without an explicit requirement, changing kselftest_harness.h
doesn't force a rebuild.

> - TEST_GEN_PROGS's .c files are already build-deps

It is not enough to trigger test rebuilds.

> 
> kselftest does, oddly, lack a common -I when KSFT_KHDR_INSTALL is set
> (which likely should get fixed, though separately from here).
> 
> I think you just want:
> 
> 
> src_test := $(wildcard *_test.c)
> TEST_GEN_PROGS := $(src_test:.c=)
> 
> KSFT_KHDR_INSTALL := 1
> include ../lib.mk
> 
> CFLAGS += -Wall -O2 -I$(BUILD)/usr/include
> LDLIBS += -lcap
> 
> $(OUTPUT)/%_test: $(BUILD)/usr/include/linux/trusted-for.h
> 
> 
> (untested)
> 
Yep, I re-checked and my Makefile is correct. I didn't find a way to
make it lighter while correctly handling dependencies.
I'll just move the -I to CFLAGS.
