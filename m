Return-Path: <SRS0=FU+R=BH=lists.openwall.com=kernel-hardening-return-19474-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B548FC433E1
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 16:57:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0D7532053B
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 16:57:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Gy0qVxQM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D7532053B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19474-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14281 invoked by uid 550); 28 Jul 2020 16:57:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5736 invoked from network); 28 Jul 2020 14:59:06 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ADCF720B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1595948334;
	bh=flkKl1tOpheQSP4WOnmrqgHroHnRne5MuepSoCZsgK0=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=Gy0qVxQM4lbk87aNiGP/UQJRoHbBkHY8gEBUc9LVHq/JBTxqOXbHBPRz/CbPhTddU
	 WUFnsrL5KmEIrg/s5uke5Hfo8z21XAplUP+QdHA3P0SR/cp8ACNVes2cfOeGq1ux6M
	 Pg8UVJmBdVVeaMAdNOiCJj8wDe04E7A1iipg0+LM=
Subject: Re: [PATCH v1 1/4] [RFC] fs/trampfd: Implement the trampoline file
 descriptor API
To: Oleg Nesterov <oleg@redhat.com>
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, x86@kernel.org
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200728131050.24443-2-madvenka@linux.microsoft.com>
 <20200728145013.GA9972@redhat.com>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <dc41589a-647a-ba59-5376-abbf5d07c6e7@linux.microsoft.com>
Date: Tue, 28 Jul 2020 09:58:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728145013.GA9972@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US

Thanks. See inline..

On 7/28/20 9:50 AM, Oleg Nesterov wrote:
> On 07/28, madvenka@linux.microsoft.com wrote:
>> +bool is_trampfd_vma(struct vm_area_struct *vma)
>> +{
>> +	struct file	*file = vma->vm_file;
>> +
>> +	if (!file)
>> +		return false;
>> +	return !strcmp(file->f_path.dentry->d_name.name, trampfd_name);
> Hmm, this looks obviously wrong or I am totally confused. A user can
> create a file named "[trampfd]", mmap it, and fool trampfd_fault() ?
>
> Why not
>
> 	return file->f_op == trampfd_fops;

This is definitely the correct check. I will fix it.
>
> ?
>
>> +EXPORT_SYMBOL_GPL(is_trampfd_vma);
> why is it exported?

This is in common code and is called by arch code. Should I not export it?
I guess since the symbol is not used by any modules, I don't need to
export it. Please confirm and I will fix this.

Madhavan

