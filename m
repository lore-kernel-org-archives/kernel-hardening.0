Return-Path: <kernel-hardening-return-21664-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id AD867C77B7C
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 May 2023 10:18:10 +0000 (UTC)
Received: (qmail 28091 invoked by uid 550); 5 May 2023 10:17:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3571 invoked from network); 5 May 2023 07:47:55 -0000
References: <20230504213002.56803-1-michael.mccracken@gmail.com>
 <fbf37518-328d-c08c-7140-5d09d7a2674f@redhat.com>
User-agent: mu4e 1.10.3; emacs 29.0.90
From: Sam James <sam@gentoo.org>
To: David Hildenbrand <david@redhat.com>
Cc: Michael McCracken <michael.mccracken@gmail.com>,
 linux-kernel@vger.kernel.org, serge@hallyn.com, tycho@tycho.pizza, Luis
 Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii
 Zaikin <yzaikin@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] sysctl: add config to make randomize_va_space RO
Date: Fri, 05 May 2023 08:46:41 +0100
In-reply-to: <fbf37518-328d-c08c-7140-5d09d7a2674f@redhat.com>
Message-ID: <87pm7f9q3q.fsf@gentoo.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain


David Hildenbrand <david@redhat.com> writes:

> On 04.05.23 23:30, Michael McCracken wrote:
>> Add config RO_RANDMAP_SYSCTL to set the mode of the randomize_va_space
>> sysctl to 0444 to disallow all runtime changes. This will prevent
>> accidental changing of this value by a root service.
>> The config is disabled by default to avoid surprises.
>
> Can you elaborate why we care about "accidental changing of this value
> by a root service"?
>
> We cannot really stop root from doing a lot of stupid things (e.g.,
> erase the root fs), so why do we particularly care here?

(I'm really not defending the utility of this, fwiw).

In the past, I've seen fuzzing tools and other debuggers try to set
it, and it might be that an admin doesn't realise that. But they could
easily set other dangerous settings unsuitable for production, so...


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iOUEARYKAI0WIQQlpruI3Zt2TGtVQcJzhAn1IN+RkAUCZFS0mV8UgAAAAAAuAChp
c3N1ZXItZnByQG5vdGF0aW9ucy5vcGVucGdwLmZpZnRoaG9yc2VtYW4ubmV0MjVB
NkJCODhERDlCNzY0QzZCNTU0MUMyNzM4NDA5RjUyMERGOTE5MA8cc2FtQGdlbnRv
by5vcmcACgkQc4QJ9SDfkZAf4wEAz3Kkey3pguBXyIJfqK+FI8qjiLI6X7SH6YJt
YEPU6oUBAMssaGW+4GhiA6nNxReLZcz2PFxEEi9/os6YSrEBD9UP
=65gP
-----END PGP SIGNATURE-----
--=-=-=--
