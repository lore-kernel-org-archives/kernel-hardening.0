Return-Path: <SRS0=oHqk=AS=lists.openwall.com=kernel-hardening-return-19245-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 861FBC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 21:52:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D3F6620663
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 21:52:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vvlth00m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3F6620663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19245-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26049 invoked by uid 550); 7 Jul 2020 21:52:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26027 invoked from network); 7 Jul 2020 21:52:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1594158723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2er0aNLBQV2gIBNyC9uXErvIZxgp1FWSJ0RFq0zI9K0=;
	b=Vvlth00mo3UYzOruXZg64Oz8KeNsHMi3xAdVfHKc8qSr7l/32GbpPTlbbKcDj5aLIUzM+8
	9baLYRaC2DOpdmsjsm7+bBKgpMiR9RtXYNCzDyooqDB1JRQ4wUBQ89qowROgd0/vkocfhL
	aQGVU11F2bI8LM5zS30zRvyX/avV3Lw=
X-MC-Unique: QUzXJQWLMESXh8DCTY5muw-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2er0aNLBQV2gIBNyC9uXErvIZxgp1FWSJ0RFq0zI9K0=;
        b=Y9KfbliVSJUPTTI0MASokTh5nON0No50kO/3Z3PrSk5OYUKwWzSsTVjN5KXPz37m6T
         jl1mR359kymHooIQWx7Vfy7orgzqlk9t1DrdoAPqwzRE3+/cd+vsWWanAvrMrnSS1YMQ
         8t28tfiDhtxB10TaaPpPwlfqAqRtiCHDpdbDdzX1LSiac3otFN/0YIkSx+al/odd9zes
         6AOAab8iCW7YicJAK9ucqrpt++dRkMd1Lg6havcceScCWXZo0mULrDf/h+lUATfRqFzG
         0kDhjK5yyRZMa/tLSGT/mMtOS5UARJ8m6Badbic3pHSnmxSvr27IVxnddZoFph8dcrfj
         FU4w==
X-Gm-Message-State: AOAM532WXHvRPOtxAzFBdcdpo76PuMqn6Opc8/y9Mc5tIVAfrcVxtZuU
	YugzDDCS5rc4Kskp34dWsCKbAGe1A1DIxglUOhNXiABZajCg2pMv2/B4ru/C0PG4cjWzdqD3K7u
	dUTIwt6Il0viFa7D5BCZ/MxaOxdnCHeaMoA==
X-Received: by 2002:a05:600c:241:: with SMTP id 1mr6023762wmj.119.1594158719935;
        Tue, 07 Jul 2020 14:51:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIpmpXuw2PJCwb7uqNw0kg7Wrr1nz+wOneSDUnHkzV5klsewRb97ktM0f//9gTqHyZmBrCjg==
X-Received: by 2002:a05:600c:241:: with SMTP id 1mr6023711wmj.119.1594158719656;
        Tue, 07 Jul 2020 14:51:59 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: x86: Introduce paravirt feature CR0/CR4 pinning
To: Dave Hansen <dave.hansen@intel.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>
Cc: "Andersen, John" <john.s.andersen@intel.com>, corbet@lwn.net,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, shuah@kernel.org, liran.alon@oracle.com, drjones@redhat.com,
 rick.p.edgecombe@intel.com, kristen@linux.intel.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 mchehab+huawei@kernel.org, gregkh@linuxfoundation.org, paulmck@kernel.org,
 pawan.kumar.gupta@linux.intel.com, jgross@suse.com, mike.kravetz@oracle.com,
 oneukum@suse.com, luto@kernel.org, peterz@infradead.org,
 fenghua.yu@intel.com, reinette.chatre@intel.com,
 vineela.tummalapalli@intel.com, dave.hansen@linux.intel.com,
 arjan@linux.intel.com, caoj.fnst@cn.fujitsu.com, bhe@redhat.com,
 nivedita@alum.mit.edu, keescook@chromium.org, dan.j.williams@intel.com,
 eric.auger@redhat.com, aaronlewis@google.com, peterx@redhat.com,
 makarandsonare@google.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kernel-hardening@lists.openwall.com
References: <20200617190757.27081-1-john.s.andersen@intel.com>
 <20200617190757.27081-3-john.s.andersen@intel.com>
 <0fa9682e-59d4-75f7-366f-103d6b8e71b8@intel.com>
 <20200618144314.GB23@258ff54ff3c0>
 <124a59a3-a603-701b-e3bb-61e83d70b20d@intel.com>
 <20200707211244.GN20096@linux.intel.com>
 <19b97891-bbb0-1061-5971-549a386f7cfb@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <31eb5b00-9e2a-aa10-0f20-4abc3cd35112@redhat.com>
Date: Tue, 7 Jul 2020 23:51:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <19b97891-bbb0-1061-5971-549a386f7cfb@intel.com>
Content-Language: en-US
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 07/07/20 23:48, Dave Hansen wrote:
> On 7/7/20 2:12 PM, Sean Christopherson wrote:
>>>>> Let's say Intel loses its marbles and adds a CR4 bit that lets userspace
>>>>> write to kernel memory.  Linux won't set it, but an attacker would go
>>>>> after it, first thing.
>> That's an orthogonal to pinning.  KVM never lets the guest set CR4 bits that
>> are unknown to KVM.  Supporting CR4.NO_MARBLES would require an explicit KVM
>> change to allow it to be set by the guest, and would also require a userspace
>> VMM to expose NO_MARBLES to the guest.
>>
>> That being said, this series should supporting pinning as much as possible,
>> i.e. if the bit can be exposed to the guest and doesn't require special
>> handling in KVM, allow it to be pinned.  E.g. TS is a special case because
>> pinning would require additional emulator support and IMO isn't interesting
>> enough to justify the extra complexity.  At a glance, I don't see anything
>> that would prevent pinning FSGSBASE.
> 
> Thanks for filling in the KVM picture.
> 
> If we're supporting as much pinning as possible, can we also add
> something to make it inconvenient for someone to both make a CR4 bit
> known to KVM *and* ignore the pinning aspects?
> 
> We should really make folks think about it.  Something like:
> 
> #define KVM_CR4_KNOWN 0xff
> #define KVM_CR4_PIN_ALLOWED 0xf0
> #define KVM_CR4_PIN_NOT_ALLOWED 0x0f
> 
> BUILD_BUG_ON(KVM_CR4_KNOWN !=
>              (KVM_CR4_PIN_ALLOWED|KVM_CR4_PIN_NOT_ALLOWED));
> 
> So someone *MUST* make an active declaration about new bits being pinned
> or not?

I would just make all unknown bits pinnable (or perhaps all CR4 bits in
general).

Paolo

