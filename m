Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1475476886-26232-4-git-send-email-elena.reshetova@intel.com>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com> <1475476886-26232-4-git-send-email-elena.reshetova@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 3 Oct 2016 14:13:10 -0700
Message-ID: <CAGXu5jKg6zCd4wwmx974+m2fW3biMoD1He52C0b9UmwsSUfnCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC PATCH 03/13] kernel: identify wrapping atomic usage
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 2, 2016 at 11:41 PM, Elena Reshetova
<elena.reshetova@intel.com> wrote:
> From: David Windsor <dwindsor@gmail.com>
>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: David Windsor <dwindsor@gmail.com>

While these patches are all doing the same mechanic changes, I think
they should still have a commit message body. Maybe something simple
like:

Switch wrapping atomic_t uses in $subsystem to atomic_t_wrap in
support of CONFIG_HARDENED_ATOMIC.

-Kees

-- 
Kees Cook
Nexus Security
