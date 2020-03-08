Return-Path: <SRS0=Qwc1=4Z=lists.openwall.com=kernel-hardening-return-18103-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4801CC10F25
	for <kernel-hardening@archiver.kernel.org>; Sun,  8 Mar 2020 00:44:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5C13E206D7
	for <kernel-hardening@archiver.kernel.org>; Sun,  8 Mar 2020 00:44:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EIC/cx4c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C13E206D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18103-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17916 invoked by uid 550); 8 Mar 2020 00:44:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17884 invoked from network); 8 Mar 2020 00:44:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zj4L55bUt0VKo5UGSqIq3zOibu7Jk8nCICwTF8MSTzY=;
        b=EIC/cx4cU7IZL+eV70nEit1rZ3QWZyKCH6XyTSEFolDzxmlBf0On/fyQbzMiuFR6eE
         ZdqVoofNNFt2O8j2Mm//T8Hi3JEZGWXRhOzTPh1riFPIaHYaDnTdc5n3jaE//yjj0rF5
         DC2/e0B3WirIUO1ex9NNXGzXxet+7q8RqclEOWijaxXSK0SERoH1lGpKxGtyBIRcwmJd
         KjTilCQTmfNVYXlb6Fh59lG3fOv8T3yvNFkWZ5eB1K1P5F+SNUNI/anVisqnlCye0gOr
         f16yq++QnFd+p3DMlbZma7CMWOixHLEaPKM0ifo9gGHdSPFjuBEaciC5KIP+3CChG392
         QBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zj4L55bUt0VKo5UGSqIq3zOibu7Jk8nCICwTF8MSTzY=;
        b=HHrIMWSWZMVU+BIdd+uKjVheWGbXoTBoFivud4XQEew0YJNa12NR9jmXZw0ujqh85Q
         x/TDvQA8W2EwyVzEEmPR1T/KpmDCbKSzAd+SN5zfxfq7BWdRsUwlH+mGUK4mG0nY5738
         HM0N8adv4rb0ezOcoN7UEmJROebd8hQdrvnFY9dGR5vyfYeWM+WKh6vhSKUnWdbCCy3B
         fsW0bh8hjCXUqf2kyWGDup0l4tkcpCfhZosadqXEP1i1PqEC5fCuKkpR09CpprFxoUo9
         gnSqhm2z6v4uWyZwkiW9IN4mgzHXqHHwpLq7VQx+TvYdTSjASVmbpVUPqYMa2hfhNHEM
         yR4A==
X-Gm-Message-State: ANhLgQ3/5iag1M/xu+OmtljUknMVY58KpLJazMCLvnIPi0NZXC7/nY97
	+LbcTraZg9xQt8EtSDtDhh8=
X-Google-Smtp-Source: ADFU+vv7fHB+8fAqx7yJfXHcmQiShFNVRCfss7BcGDsYYThwi+w34pWK7cL2D1HJp3ADz98/npKCzw==
X-Received: by 2002:a63:d658:: with SMTP id d24mr10107920pgj.340.1583628269497;
        Sat, 07 Mar 2020 16:44:29 -0800 (PST)
To: alex.popov@linux.com
Cc: Andrey Konovalov <andreyknvl@google.com>,
 kernel-hardening@lists.openwall.com, Shawn <citypw@hardenedlinux.org>,
 spender@grsecurity.net, Jann Horn <jannh@google.com>,
 Kees Cook <keescook@chromium.org>
References: <e535d698-5268-e5fc-a238-0649c509cc4f@gmail.com>
 <CAAeHK+y-FdpH20Z7HsB0U+mgD9CK0gECCqShXFtFWpFp01jAmA@mail.gmail.com>
 <84b3a89a-cd20-1e49-8d98-53b74dd3f9d1@linux.com>
 <68e01bc3-f218-01a1-2398-ec51ffa11109@gmail.com>
 <04e89784-5ca8-0ecc-2735-4196ace74b0b@linux.com>
From: zerons <zeronsaxm@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=zeronsaxm@gmail.com; prefer-encrypt=mutual; keydata=
 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
Subject: Re: Maybe inappropriate use BUG_ON() in CONFIG_SLAB_FREELIST_HARDENED
Message-ID: <e8125c86-7638-e5bc-eb9f-fca8b009f219@gmail.com>
Date: Sun, 8 Mar 2020 08:44:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <04e89784-5ca8-0ecc-2735-4196ace74b0b@linux.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 2/27/20 19:28, Alexander Popov wrote:
> On 19.02.2020 16:43, zerons wrote:
>> This patch does work for cve-2017-2636 case, it is barely impossible to win the
>> race. My concern is based on an assumption: we do have a double kfree() bug and
>> we can win the race.
> 
> Yes, I agree that the double-free check in CONFIG_SLAB_FREELIST_HARDENED can be
> bypassed in some cases by winning the race and inserting kmalloc() between kfree().
> 
> But I *don't* agree that this double-free check can help the attacker.
> 
> Without this check in CONFIG_SLAB_FREELIST_HARDENED, double-free exploitation is
> always easier, since the attacker has no need to race at all. In the write-up
> about CVE-2017-2636 exploit [1] I showed how to do heap spray *after*
> double-free (kfree-kfree-kmalloc-kmalloc).
> 

I thought the freelist obfuscation[1] and prefecth next pointer[2]
may block this method(kfree-kfree-kmalloc-kmalloc), and the
prefetch_freepointer() should've stopped the 2nd kmalloc().

Today, I did some tests on Ubuntu 18.04 with kernel 5.3.18,
without your patch.

Here is the code. It writes something to modprobe_path for debugging.
After the 2nd kmalloc() return, ptr0 == ptr1 is true, which means
the attacker could have two objects point to same memory area.

Although the system now is quite fragile: the next kmalloc()
would trigger do_general_protection() since the c->freelist is
something like 0x4141414141414141, the attacker still can win.

=======================================================================
#define TARGET_SIZE	0x1000
static int __init test_init(void)
{
	char *ptr0, *ptr1, *ptr2;
	char *path_addr;
	size_t l = 0;

	path_addr = (char *)kallsyms_lookup_name("modprobe_path");
	while (1) {
		if (!*(path_addr+l))
			break;
		l++;
	}
	l += 8 - (l%8);

	ptr0 = kmalloc(TARGET_SIZE, GFP_KERNEL);
	*(unsigned long *)(path_addr+l) = (unsigned long)ptr0;
	kfree(ptr0);
	*(unsigned long *)(path_addr+l+8) = *(unsigned long *)ptr0;

	*(unsigned long *)(path_addr+l+0x10) = (unsigned long)ptr0;
	kfree(ptr0);
	*(unsigned long *)(path_addr+l+0x18) = *(unsigned long *)ptr0;

	ptr0 = kmalloc(TARGET_SIZE, GFP_KERNEL);
	*(unsigned long *)(path_addr+l+0x20) = (unsigned long)ptr0;
	*(unsigned long *)(path_addr+l+0x28) = *(unsigned long *)ptr0;

	ptr1 = kmalloc(TARGET_SIZE, GFP_KERNEL);
	*(unsigned long *)(path_addr+l+0x30) = (unsigned long)ptr1;
	*(unsigned long *)(path_addr+l+0x38) = *(unsigned long *)ptr0;

#if 0
	ptr2 = kmalloc(TARGET_SIZE, GFP_KERNEL);
	*(unsigned long *)(path_addr+l+0x40) = (unsigned long)ptr2;
	*(unsigned long *)(path_addr+l+0x48) = *(unsigned long *)ptr0;
#endif

	return 0;
}
==========================================================================


[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2482ddec
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0ad9500e1
