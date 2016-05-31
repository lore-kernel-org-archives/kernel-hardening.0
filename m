Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <4eae2961-e625-e249-868c-7ccd3ad1f8d0@marcan.st>
References: <a0e27065-afec-d82f-c478-1c311adaea3d@marcan.st>
 <CAGXu5jKqCJB7L+T_ghv=qixt4J_eq4L6+o5MwueTZ8_GVfeDTQ@mail.gmail.com>
 <727dd7b4-e33f-e53d-f4f9-a6f9c57e2b63@marcan.st> <CAGXu5jLv8J0+nizD8zjWScpF_SJmuBg+-z9hpE7HiP0sD2B+Vg@mail.gmail.com>
 <4eae2961-e625-e249-868c-7ccd3ad1f8d0@marcan.st>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 31 May 2016 10:25:00 -0700
Message-ID: <CAGXu5jJruX++kxqyvB0avFafbe07R3J3mCorqZD8Fs2n1uztsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 1/3] Add the latent_entropy gcc plugin
To: Hector Martin marcan <marcan@marcan.st>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 30, 2016 at 1:24 PM, Hector Martin "marcan"
<marcan@marcan.st> wrote:
> Then there is the other side: is there are reason not to just make the
> plugin v2v3? That would certainly remove all doubt and potential issues,
> and complies with both GCC's license and the kernel's.

If that works, please take it up with the plugin authors. You and I
aren't going to convince each other, and I'm satisfied with the
licensing as it already is.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
