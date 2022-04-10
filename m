Return-Path: <kernel-hardening-return-21557-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id CB9FAC433EF
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 Apr 2022 21:03:08 +0000 (UTC)
Received: (qmail 7844 invoked by uid 550); 10 Apr 2022 21:02:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1902 invoked from network); 10 Apr 2022 19:34:39 -0000
Message-ID: <6b039403-b46e-e186-63d0-91362dfe18a1@arbtirary.ch>
Date: Sun, 10 Apr 2022 21:34:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
From: Peter Gerber <peter@arbtirary.ch>
Subject: Kernel Self Protection Project: slub_debug=ZF
Content-Language: en-US
To: kernel-hardening@lists.openwall.com
Cc: linux-hardening@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

The Kernel Self Protection Project, on their Recommended Settings [1] 
page, suggests the following:

# Enable SLUB redzoning and sanity checking (slow; requires 
CONFIG_SLUB_DEBUG=y above).
slub_debug=ZF

On recent kernels, I see the following in dmesg when this option is set:

**********************************************************
**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
**                                                      **
** This system shows unhashed kernel memory addresses   **
** via the console, logs, and other interfaces. This    **
** might reduce the security of your system.            **
**                                                      **
** If you see this message and you are not debugging    **
** the kernel, report this immediately to your system   **
** administrator!                                       **
**                                                      **
**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
**********************************************************

A bit of digging tells me that this is caused by "slub: force on 
no_hash_pointers when slub_debug is enabled" [2]. Assuming the 
performance impact is acceptable, is this option still recommend? Should 
there perhaps be a way to explicitly disable no_hash_pointers (e.g. via 
no_hash_pointers=off)?

Regards,

Peter

[1]: 
https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings
[2]: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=792702911f581f7793962fbeb99d5c3a1b28f4c3
