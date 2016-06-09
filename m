Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160609004758.GA8658@grsecurity.net>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
 <1465420302-23754-2-git-send-email-keescook@chromium.org> <20160609004758.GA8658@grsecurity.net>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 Jun 2016 19:58:10 -0700
Message-ID: <CAGXu5jLEKczJF1MD7nncK6WMLXt+rm7ieWQ_MmphA=m63mbcyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/4] mm: Hardened usercopy
To: Brad Spengler <spender@grsecurity.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 8, 2016 at 5:47 PM, Brad Spengler <spender@grsecurity.net> wrote:
>> diff --git a/mm/usercopy.c b/mm/usercopy.c
>> new file mode 100644
>> index 000000000000..e09c33070759
>> --- /dev/null
>> +++ b/mm/usercopy.c
>> @@ -0,0 +1,177 @@
>> +/*
>> + * This implements the various checks for CONFIG_HARDENED_USERCOPY*,
>> + * which are designed to protect kernel memory from needless exposure
>> + * and overwrite under many conditions.
>> + */
>
> As this is a new file being introduced which is (modulo some bikeshedding
> and addition of a few comments) a direct copy+paste of our code and comments
> in fs/exec.c, I would appreciate both a GPL notice (the same as exists for
> KASAN, etc) and both the PaX Team and myself being listed as the copyright
> owners.

Sure thing! I'll include it in the next revision. Do you have specific
text and/or date ranges you'd prefer me to use?

Thanks,

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
