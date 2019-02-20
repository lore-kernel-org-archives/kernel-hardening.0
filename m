MIME-Version: 1.0
References: <20190218232308.11241-1-tobin@kernel.org>
In-Reply-To: <20190218232308.11241-1-tobin@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Feb 2019 15:31:07 -0800
Message-ID: <CAGXu5j+gHMCjxMr3k0UNBcsT6DYuALtpROxazf7YVX=SUja_cQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] lib: Add safe string funtions
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <tobin@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 18, 2019 at 3:24 PM Tobin C. Harding <tobin@kernel.org> wrote:
> During your talk at LCA you mentioned that we could do with a couple
> more safe string functions.  One to zero the tail of the destination
> buffer after call to strscpy() and also the self explanatory
> strscpy_from_user().

Thanks for jumping in with this! :)

> I couldn't work out if this is a false positive or not?  Does the new
> config option CONFIG_TEST_STRING need more documentation?  I don't see
> where extra docs should be added and it seems self explanatory as is.

Usually this just means the help string in Kconfig is "too short".
Sometimes this is a false positive -- really up to you if you think it
needs more. :)

On to individual patches...

-- 
Kees Cook
