Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 17 Dec 2015 13:55:32 -0800
From: David Brown <david.brown@linaro.org>
Message-ID: <20151217215532.GA64407@davidb.org>
References: <1450331796-10329-1-git-send-email-dave@progbits.org>
 <1450331796-10329-6-git-send-email-dave@progbits.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1450331796-10329-6-git-send-email-dave@progbits.org>
Subject: Re: [kernel-hardening][RFC PATCH 5/5] lkdtm: add test for atomic_t
 underflow/overflow
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 17, 2015 at 12:56:36AM -0500, David Windsor wrote:

>diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
>index b5abe34..5002747 100644
>--- a/drivers/misc/lkdtm.c
>+++ b/drivers/misc/lkdtm.c
>@@ -104,6 +104,7 @@ enum ctype {
> 	CT_ACCESS_USERSPACE,
> 	CT_WRITE_RO,
> 	CT_WRITE_KERN,
>+    CT_WRAP_ATOMIC
> };
>
> static char* cp_name[] = {

You seem to be indenting with spaces rather than tabs.  It'd probably
be a good idea to run checkpatch on the patches.  It should catch
this.

David
