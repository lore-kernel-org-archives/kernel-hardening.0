Return-Path: <SRS0=C5bn=L3=lists.openwall.com=kernel-hardening-return-21331-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CFFC07E97
	for <kernel-hardening@archiver.kernel.org>; Sat,  3 Jul 2021 11:00:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AC4D5615A0
	for <kernel-hardening@archiver.kernel.org>; Sat,  3 Jul 2021 11:00:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC4D5615A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21331-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27754 invoked by uid 550); 3 Jul 2021 11:00:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27731 invoked from network); 3 Jul 2021 11:00:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1625309984;
	bh=x6a2MKj2i7ny1X6EqqStry+6FExFMd0ABQRz2nQeLYo=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wiw7YHneNAj0vRJgTC3prnFX86jII+xEDVN++I+m01JfvLFWKYMxNJThVpPmfNaMr
	 0l1XkxxecRdMGd/ExVwB/L5tXY2XP/EGhE0aQbXZspLThbZgfj0sACe7WncRlHxXDF
	 B6jPov8MEaN5iDIh2XMcRMHpdZpAmshp2gYuSPWM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 3 Jul 2021 12:59:28 +0200
From: John Wood <john.wood@gmx.com>
To: Alexander Lobakin <alobakin@pm.me>
Cc: John Wood <john.wood@gmx.com>, Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>, Andi Kleen <ak@linux.intel.com>,
	valdis.kletnieks@vt.edu,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v8 3/8] security/brute: Detect a brute force attack
Message-ID: <20210703105928.GA2830@ubuntu>
References: <20210701234807.50453-1-alobakin@pm.me>
 <20210702145954.GA4513@ubuntu>
 <20210702170101.16116-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702170101.16116-1-alobakin@pm.me>
X-Provags-ID: V03:K1:IYa/f7HkDU74IlmbpIDqxZ4UnHLocuh2xK/SRcmGwjgHVE0HPwO
 uvk+ZKPo3XYM/EQ0BhfLQneFfb/z4C4sbQPYymJxVpCLHfTj4keZV746Dag/i+ohT+Tx1/V
 AzMPePnTmSZE/IiVBtMBldhthrEDhpmLHPUvlxEw3x6L7ewUJ/S8yXJnOJgUuMKIApCRwsB
 4agKpfVPAEAY+DauJZ2HA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DDK8tn1k2vk=:EF86SSfY5Vi1KOs8AADY/a
 3Cq2nb4xqxxZWH6qOL0VjCqZO9d4DZ7Xx/yAQlHXGZaBU+BQ//fuZI6ljkHqeWhwUkyLivscc
 qJgrFJ313EhAax10IlN6i1M2HXjw7HFxHekHYXtWwHUYHiWGVHeFwp3HWdCHEbX21FM/z6bXL
 zbscFiWSbWbcUUPbI4VBKkn12UFjq4r/w+sJ3Wkjny6xTDMx8wbkpoSBxAt0PC2QPFtFZPuM2
 sSm+saVCm0M1Eiqc9eizWMW64iyInEgBFtl/OJgcUzWq32x9bffwJ2rRgCSnXY24TrNgA0eo9
 JuqFZjKk3zr/20QNa8alL/Szxz+uUm5vc26NKd1EUyj67cJ+MxBKjcZfRJ4UMeSWIz2rK2H/Y
 uNP6v0PiZxFM2+MrI8UWw4WB74DT8jySibpghnRylZJs0Zpxj488MnwjJpEcugPNQyH6TkvoV
 XyV+/H9qAca+7u803Q3j9Vd/CFiLjyg7/nNcVpWALQe2Yu6R/6OE8VjwSTFFj37xS7ZDhtQ29
 xdJuoIZO7calbQyUhmUsCL2R38DX+T5ozjbZMc9nKiaTIWhqS70cw/HDnyAi+SYt+STd8Dc3h
 xeIMzJmj5dh47yDhj3YDLxvhLR1toQzatbzLPCnFzt8FflC/wTt5aLeCUlhgUjQXmEqCPKtKb
 7klmaSE/q595gmB8f2vi9R2LVvqG1UnyniXMCPW8nK0M0fLu4A45lUI3YpltthQPiHyO6nFKq
 Q/EeJiCLhjlyXwrEVTEE0KXA0n7zeYn6YN8h+xbC5dVYHOuiyi/eHBVur9KI9YV8lvxIYngGL
 VhgBJG4qW9KikFkNqMW1vmycs/t4n3KK0LaIZ0mIWF9WbTi7L5Vmd5EddLHnus9fnZQ9uUMcJ
 Knw313I1cIzVHCWrbb2vGYEOmMWa+3833cxeeRkazB2b9GD8HV4otN6tlw0/5zPjSVSoNlDhn
 Vevn56H0Y2whovHFCeakw8UqVk0gBkGsJSAMKzdVigvQcZYJ1B2lvCBf4/KiJYCrBwLPc0M/t
 CVgINq6H165/dOQ56gS1Fn1YxsFGT8XM0HMzCXZPplvjeA2uDcschlVNk3gPtiXpax5kZoD76
 SG2hbzUGdtKbMfttCXBP3mz/FXlbgtHans7
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 02, 2021 at 05:08:09PM +0000, Alexander Lobakin wrote:
>
> On the other hand, it leaves a potentional window for attackers to
> perform brute force from xattr-incapable filesystems. So at the end
> of the day I think that the current implementation (a strong
> rejection of such filesystems) is way more secure than having
> a fallback I proposed.

I've been thinking more about this: that the Brute LSM depends on xattr
support and I don't like this part. I want that brute force attacks can
be detected and mitigated on every system (with minimal dependencies).
So, now I am working in a solution without this drawback. I have some
ideas but I need to work on it.

> I'm planning to make a patch which will eliminate such weird rootfs
> type selection and just always use more feature-rich tmpfs if it's
> compiled in. So, as an alternative, you could add it to your series
> as a preparatory change and just add a Kconfig dependency on
> CONFIG_TMPFS && CONFIG_TMPFS_XATTR to CONFIG_SECURITY_FORK_BRUTE
> without messing with any fallbacks at all.
> What do you think?

Great. But I hope this patch will not be necessary for Brute LSM :)

Thanks,
John Wood
