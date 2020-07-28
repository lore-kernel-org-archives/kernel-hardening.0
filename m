Return-Path: <SRS0=qxDK=BH=lists.openwall.com=kernel-hardening-return-19482-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B7AC433E3
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 17:40:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EB57420672
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 17:40:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="BD8peru3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB57420672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19482-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24411 invoked by uid 550); 28 Jul 2020 17:40:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24385 invoked from network); 28 Jul 2020 17:40:12 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EFB9B20B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1595958000;
	bh=OWWDkY3sg+0Hy6NDKMgflfpDtA2CgO3csqL7Uid/wVU=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=BD8peru37WXTYWBqj5OMIGNR9eoysAlugyqLDVTBV7w4kOP+8hTAhlmNbuHLu2zxq
	 BAe3qmozLc1x5RhrrRLkdkoFmsJNoPrTf/LsfjmUXd6yl0jYTkjwlmSijRnjte7hxb
	 h/uMH3jra/wLEJewhLEScRvmJf8hFnDjqSPBMM4c=
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: Andy Lutomirski <luto@kernel.org>
Cc: David Laight <David.Laight@aculab.com>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-security-module@vger.kernel.org"
 <linux-security-module@vger.kernel.org>, "oleg@redhat.com"
 <oleg@redhat.com>, "x86@kernel.org" <x86@kernel.org>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <c23de6ec47614f489943e1a89a21dfa3@AcuMS.aculab.com>
 <f5cfd11b-04fe-9db7-9d67-7ee898636edb@linux.microsoft.com>
 <CALCETrUta5-0TLJ9-jfdehpTAp2Efmukk2npYadFzz9ozOrG2w@mail.gmail.com>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <81d744c0-923e-35ad-6063-8b186f6a153c@linux.microsoft.com>
Date: Tue, 28 Jul 2020 12:39:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALCETrUta5-0TLJ9-jfdehpTAp2Efmukk2npYadFzz9ozOrG2w@mail.gmail.com>
Content-Type: multipart/alternative;
 boundary="------------AD9A0AC3BF44AC5296C62689"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------AD9A0AC3BF44AC5296C62689
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit



On 7/28/20 12:16 PM, Andy Lutomirski wrote:
> On Tue, Jul 28, 2020 at 9:32 AM Madhavan T. Venkataraman
> <madvenka@linux.microsoft.com> wrote:
>> Thanks. See inline..
>>
>> On 7/28/20 10:13 AM, David Laight wrote:
>>> From:  madvenka@linux.microsoft.com
>>>> Sent: 28 July 2020 14:11
>>> ...
>>>> The kernel creates the trampoline mapping without any permissions. When
>>>> the trampoline is executed by user code, a page fault happens and the
>>>> kernel gets control. The kernel recognizes that this is a trampoline
>>>> invocation. It sets up the user registers based on the specified
>>>> register context, and/or pushes values on the user stack based on the
>>>> specified stack context, and sets the user PC to the requested target
>>>> PC. When the kernel returns, execution continues at the target PC.
>>>> So, the kernel does the work of the trampoline on behalf of the
>>>> application.
>>> Isn't the performance of this going to be horrid?
>> It takes about the same amount of time as getpid(). So, it is
>> one quick trip into the kernel. I expect that applications will
>> typically not care about this extra overhead as long as
>> they are able to run.
> What did you test this on?  A page fault on any modern x86_64 system
> is much, much, much, much slower than a syscall.

I tested it in on a KVM guest running Ubuntu. So, when you say
that a page fault is much slower, do you mean a regular page
fault that is handled through the VM layer? Here is the relevant code
in do_user_addr_fault():

            if (unlikely(access_error(hw_error_code, vma))) {
                    /*
                     * If it is a user execute fault, it could be a trampoline
                     * invocation.
                     */
                    if ((hw_error_code & tflags) == tflags &&
                        trampfd_fault(vma, regs)) {
                            up_read(&mm->mmap_sem);
                            return;
                    }
                    bad_area_access_error(regs, hw_error_code, address, vma);
                    return;
            }

            /*
             * If for any reason at all we couldn't handle the fault,
             * make sure we exit gracefully rather than endlessly redo
             * the fault.  Since we never set FAULT_FLAG_RETRY_NOWAIT, if
             * we get VM_FAULT_RETRY back, the mmap_sem has been unlocked.
             *
             * Note that handle_userfault() may also release and reacquire mmap_sem
             * (and not return with VM_FAULT_RETRY), when returning to userland to
             * repeat the page fault later with a VM_FAULT_NOPAGE retval
             * (potentially after handling any pending signal during the return to
             * userland). The return to userland is identified whenever
             * FAULT_FLAG_USER|FAULT_FLAG_KILLABLE are both set in flags.
             */
            fault = handle_mm_fault(vma, address, flags);

trampfd faults are instruction faults that go through a different code
path than the one that calls handle_mm_fault().

Could you clarify?

Thanks.

Madhavan


--------------AD9A0AC3BF44AC5296C62689
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <br>
    <br>
    <div class="moz-cite-prefix">On 7/28/20 12:16 PM, Andy Lutomirski
      wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:CALCETrUta5-0TLJ9-jfdehpTAp2Efmukk2npYadFzz9ozOrG2w@mail.gmail.com">
      <pre class="moz-quote-pre" wrap="">On Tue, Jul 28, 2020 at 9:32 AM Madhavan T. Venkataraman
<a class="moz-txt-link-rfc2396E" href="mailto:madvenka@linux.microsoft.com">&lt;madvenka@linux.microsoft.com&gt;</a> wrote:
</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">
Thanks. See inline..

On 7/28/20 10:13 AM, David Laight wrote:
</pre>
        <blockquote type="cite">
          <pre class="moz-quote-pre" wrap="">From:  <a class="moz-txt-link-abbreviated" href="mailto:madvenka@linux.microsoft.com">madvenka@linux.microsoft.com</a>
</pre>
          <blockquote type="cite">
            <pre class="moz-quote-pre" wrap="">Sent: 28 July 2020 14:11
</pre>
          </blockquote>
          <pre class="moz-quote-pre" wrap="">...
</pre>
          <blockquote type="cite">
            <pre class="moz-quote-pre" wrap="">The kernel creates the trampoline mapping without any permissions. When
the trampoline is executed by user code, a page fault happens and the
kernel gets control. The kernel recognizes that this is a trampoline
invocation. It sets up the user registers based on the specified
register context, and/or pushes values on the user stack based on the
specified stack context, and sets the user PC to the requested target
PC. When the kernel returns, execution continues at the target PC.
So, the kernel does the work of the trampoline on behalf of the
application.
</pre>
          </blockquote>
          <pre class="moz-quote-pre" wrap="">Isn't the performance of this going to be horrid?
</pre>
        </blockquote>
        <pre class="moz-quote-pre" wrap="">
It takes about the same amount of time as getpid(). So, it is
one quick trip into the kernel. I expect that applications will
typically not care about this extra overhead as long as
they are able to run.
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
What did you test this on?  A page fault on any modern x86_64 system
is much, much, much, much slower than a syscall.</pre>
    </blockquote>
    <br>
    I tested it in on a KVM guest running Ubuntu. So, when you say<br>
    that a page fault is much slower, do you mean a regular page<br>
    fault that is handled through the VM layer? Here is the relevant
    code<br>
    in do_user_addr_fault():<br>
    <br>
    <blockquote> <font size="-1">       if
        (unlikely(access_error(hw_error_code, vma))) {</font><br>
      <font size="-1">                /*</font><br>
      <font size="-1">                 * If it is a user execute fault,
        it could be a trampoline</font><br>
      <font size="-1">                 * invocation.</font><br>
      <font size="-1">                 */</font><br>
      <font size="-1">                if ((hw_error_code &amp; tflags)
        == tflags &amp;&amp;</font><br>
      <font size="-1">                    trampfd_fault(vma, regs)) {</font><br>
      <font size="-1">                       
        up_read(&amp;mm-&gt;mmap_sem);</font><br>
      <font size="-1">                        return;</font><br>
      <font size="-1">                }</font><br>
      <font size="-1">                bad_area_access_error(regs,
        hw_error_code, address, vma);</font><br>
      <font size="-1">                return;</font><br>
      <font size="-1">        }</font><br>
      <br>
      <font size="-1">        /*</font><br>
      <font size="-1">         * If for any reason at all we couldn't
        handle the fault,</font><br>
      <font size="-1">         * make sure we exit gracefully rather
        than endlessly redo</font><br>
      <font size="-1">         * the fault.  Since we never set
        FAULT_FLAG_RETRY_NOWAIT, if</font><br>
      <font size="-1">         * we get VM_FAULT_RETRY back, the
        mmap_sem has been unlocked.</font><br>
      <font size="-1">         *</font><br>
      <font size="-1">         * Note that handle_userfault() may also
        release and reacquire mmap_sem</font><br>
      <font size="-1">         * (and not return with VM_FAULT_RETRY),
        when returning to userland to</font><br>
      <font size="-1">         * repeat the page fault later with a
        VM_FAULT_NOPAGE retval</font><br>
      <font size="-1">         * (potentially after handling any pending
        signal during the return to</font><br>
      <font size="-1">         * userland). The return to userland is
        identified whenever</font><br>
      <font size="-1">         * FAULT_FLAG_USER|FAULT_FLAG_KILLABLE are
        both set in flags.</font><br>
      <font size="-1">         */</font><br>
      <font size="-1">        fault = handle_mm_fault(vma, address,
        flags);</font><br>
    </blockquote>
    trampfd faults are instruction faults that go through a different
    code<br>
    path than the one that calls handle_mm_fault().<br>
    <br>
    Could you clarify?<br>
    <br>
    Thanks.<br>
    <br>
    Madhavan
    <blockquote type="cite"
cite="mid:CALCETrUta5-0TLJ9-jfdehpTAp2Efmukk2npYadFzz9ozOrG2w@mail.gmail.com"></blockquote>
    <br>
  </body>
</html>

--------------AD9A0AC3BF44AC5296C62689--
