MIME-Version: 1.0
In-Reply-To: <20170830095735.GB31503@amd>
References: <20170816231458.2299-1-labbott@redhat.com> <20170816231458.2299-3-labbott@redhat.com>
 <20170817033148.ownsmbdzk2vhupme@thunk.org> <20170830095735.GB31503@amd>
From: Nick Kralevich <nnk@google.com>
Date: Wed, 30 Aug 2017 06:27:40 -0700
Message-ID: <CAFJ0LnEduPL4RJLyJv-pZdrncfwS0r1mQ_26tKASDB4nf-Xjjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCHv3 2/2] extract early boot entropy
 from the passed cmdline
To: Pavel Machek <pavel@ucw.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, kernel-hardening@lists.openwall.com, lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 30, 2017 at 2:57 AM, Pavel Machek <pavel@ucw.cz> wrote:
> The command line is visible to unpriviledged userspace (/proc/cmdline,
> dmesg). Is that a problem?

These files are not exposed to untrusted processes on Android.

-- 
Nick Kralevich | Android Security | nnk@google.com | 650.214.4037
