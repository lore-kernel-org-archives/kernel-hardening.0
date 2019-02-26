MIME-Version: 1.0
References: <20190226233647.28547-1-keescook@chromium.org> <20190226233647.28547-4-keescook@chromium.org>
In-Reply-To: <20190226233647.28547-4-keescook@chromium.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 26 Feb 2019 15:40:34 -0800
Message-ID: <CAGXu5jJpeh5Ark4QG-UMUUkr-d+hWoBBb5eYzoGOCFXnW3xgkw@mail.gmail.com>
Subject: Re: [PATCH 3/3] lkdtm: Check for SMEP clearing protections
Content-Type: text/plain; charset="UTF-8"
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 26, 2019 at 3:37 PM Kees Cook <keescook@chromium.org> wrote:
> +       for (i = 0; i < 64; i++) {
> ...
> +       }
> +       if (i >= 256) {
> +               pr_info("ok: cannot locate cr4 writing call gadget\n");
> +               return;
> +       }

*brown paper bag*
Argh. I changed the depth of that search at the last moment and now
it's mismatched. *sigh* I will send a v2 for this with it fixed.

-- 
Kees Cook
