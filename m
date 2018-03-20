MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CA+55aFwZnkR5uA5Oe19Xzox=+Bcab-j6-+a=XGqS8yokDU3Dog@mail.gmail.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com> <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk> <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com>
 <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com>
 <42b4342b-aefc-a16a-0d43-9f9c0d63ba7a@rasmusvillemoes.dk> <CA+55aFwFoTapX2niPiaET5kg7K85qxhav1_PoDDxY0o_VRA5Ag@mail.gmail.com>
 <38b6da49-1138-017e-7307-f39ff067d6d2@rasmusvillemoes.dk> <CA+55aFw0WC+S3TTE6x_vkLbRV6YLeR4-1S9LsBXhE+E2KZqBuA@mail.gmail.com>
 <0e94e9582bec4373b5e21c612be179ac@AcuMS.aculab.com> <CA+55aFwZnkR5uA5Oe19Xzox=+Bcab-j6-+a=XGqS8yokDU3Dog@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 20 Mar 2018 11:10:12 +0800
Message-ID: <CAK8P3a23f2SjjNiLXaf83K2-LmQcEz_RT2gqgydJ5-k5TJpUOw@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Laight <David.Laight@aculab.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 20, 2018 at 7:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Mar 19, 2018 at 2:43 AM, David Laight <David.Laight@aculab.com> wrote:
>>
>> Is it necessary to have the full checks for old versions of gcc?
>>
>> Even -Wvla could be predicated on very recent gcc - since we aren't
>> worried about whether gcc decides to generate a vla, but whether
>> the source requests one.
>
> You are correct. We could just ignore the issue with old gcc versions,
> and disable -Wvla rather than worry about it.

This version might also be an option:

diff --git a/Makefile b/Makefile
index 37fc475a2b92..49dd9f0fb76c 100644
--- a/Makefile
+++ b/Makefile
@@ -687,7 +687,8 @@ KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
 endif

 ifneq ($(CONFIG_FRAME_WARN),0)
-KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
+KBUILD_CFLAGS += $(call cc-option,-Wstack-usage=${CONFIG_FRAME_WARN}, \
+               -$(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN}))
 endif

 # This selects the stack protector compiler flag. Testing it is delayed

Wiht -Wstack-usage=, we should get a similar warning to -Wvla for frames that
contain real VLAs, but not when there is a VLA that ends up being a compile-time
constant size in the end. Wstack-usage was introduced in gcc-4.7, so
on older versions
it turns back into Wframe-larger-than=.

An example output would be

security/integrity/ima/ima_crypto.c: In function 'ima_calc_buffer_hash':
security/integrity/ima/ima_crypto.c:616:5: error: stack usage might be
unbounded [-Werror=stack-usage=]

        Arnd
