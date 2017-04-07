Date: Thu, 6 Apr 2017 18:58:19 -0700
From: Jessica Yu <jeyu@redhat.com>
Message-ID: <20170407015819.djxqzd2e5i3dd2dt@jeyu>
References: <20170406033550.32525-1-ewk@edkovsky.org>
 <20170406033550.32525-2-ewk@edkovsky.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20170406033550.32525-2-ewk@edkovsky.org>
Subject: [kernel-hardening] Re: [PATCH v5 1/2] module: verify address is read-only
To: Eddie Kovsky <ewk@edkovsky.org>
Cc: rusty@rustcorp.com.au, keescook@chromium.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

+++ Eddie Kovsky [05/04/17 21:35 -0600]:
>Implement a mechanism to check if a module's address is in
>the rodata or ro_after_init sections. It mimics the existing functions
>that test if an address is inside a module's text section.
>
>Functions that take a module as an argument will be able to verify that the
>module address is in a read-only section. The idea is to prevent structures
>(including modules) that are not read-only from being passed to functions.
>
>This implements the first half of a suggestion made by Kees Cook for
>the Kernel Self Protection Project:
>
>    - provide mechanism to check for ro_after_init memory areas, and
>      reject structures not marked ro_after_init in vmbus_register()
>
>Suggested-by: Kees Cook <keescook@chromium.org>
>Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>

Acked-by: Jessica Yu <jeyu@redhat.com>
