Return-Path: <kernel-hardening-return-21521-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 049B8C433EF
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Dec 2021 17:41:12 +0000 (UTC)
Received: (qmail 28559 invoked by uid 550); 27 Dec 2021 17:41:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28530 invoked from network); 27 Dec 2021 17:41:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1640626851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YAHdEgA4vBfChhqcXFr18t3cp4WP7TtGCi10QnGN9O0=;
	b=GUas0yw6GFfw8OeL62q1eucxiwNMdorPJzKLuvgroxDdoh8TytFtMwDDcLs9WfRAKevfpI
	CSAl2Cu2UHfURezSsnYXZiANYERVfD556HJYcz9JoNIMDkge75CLfuyychdqjAcJx1Et9H
	SAGh7j+bKXEJe7Ye4xRlvdGWgg51+Cc=
X-MC-Unique: N8MuQBfBMpGw50_ypxFLLA-1
From: Florian Weimer <fweimer@redhat.com>
To: Andrei Vagin <avagin@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>,  linux-arch@vger.kernel.org,  Linux
 API <linux-api@vger.kernel.org>,  linux-x86_64@vger.kernel.org,
  kernel-hardening@lists.openwall.com,  linux-mm@kvack.org,  "the arch/x86
 maintainers" <x86@kernel.org>,  musl@lists.openwall.com,
  libc-alpha@sourceware.org,  LKML <linux-kernel@vger.kernel.org>,  Dave
 Hansen <dave.hansen@intel.com>,  Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] x86: Implement arch_prctl(ARCH_VSYSCALL_CONTROL) to
 disable vsyscall
References: <878rwkidtf.fsf@oldenburg.str.redhat.com>
	<CANaxB-xpQr1mUUvWK5a53q49VK_HvR4Pws_NGKGa8-jihxkc_A@mail.gmail.com>
Date: Mon, 27 Dec 2021 18:40:38 +0100
In-Reply-To: <CANaxB-xpQr1mUUvWK5a53q49VK_HvR4Pws_NGKGa8-jihxkc_A@mail.gmail.com>
	(Andrei Vagin's message of "Mon, 27 Dec 2021 08:49:38 -0800")
Message-ID: <87o8520wvd.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13

* Andrei Vagin:

>> diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
>> index fd2ee9408e91..8eb3bcf2cedf 100644
>> --- a/arch/x86/entry/vsyscall/vsyscall_64.c
>> +++ b/arch/x86/entry/vsyscall/vsyscall_64.c
>> @@ -174,6 +174,12 @@ bool emulate_vsyscall(unsigned long error_code,
>>
>>         tsk = current;
>>
>> +       if (tsk->mm->context.vsyscall_disabled) {
>> +               warn_bad_vsyscall(KERN_WARNING, regs,
>> +                                 "vsyscall after lockout (exploit attempt?)");
>
> I don't think that we need this warning message. If we disable
> vsyscall, its address range is not differ from other addresses around
> and has to be handled the same way. For example, gVisor or any other
> sandbox engines may want to emulate vsyscall, but the kernel log will
> be full of such messages.

But with vsyscall=none, such messages are already printed.  That's why I
added the warning for the lockout case as well.

>> diff --git a/tools/testing/selftests/x86/vsyscall_control.c b/tools/testing/selftests/x86/vsyscall_control.c
>> new file mode 100644
>> index 000000000000..ee966f936c89
>> --- /dev/null
>> +++ b/tools/testing/selftests/x86/vsyscall_control.c
>
> I would move the test in a separate patch...

I can do that if it simplifies matters.

Thanks,
Florian

