MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAOp4FwQHq6X9Y7eP-cSxAi8iL66Go5nZoueN8HW65vxHhmWdZw@mail.gmail.com>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
 <1491513513-84351-2-git-send-email-keescook@chromium.org> <CAGXu5jL6XvC0gSFhtpOKRJ3nR2ZQjz4aaaMyak8PAvuHF2Ee1Q@mail.gmail.com>
 <20170417053052.dz276h26jxwdfhsr@jeyu> <CAGXu5jKqFoY_TQXFa++NY1as2FrjO9=NZVmiFgr3AuW06SFWYg@mail.gmail.com>
 <CAOp4FwQHq6X9Y7eP-cSxAi8iL66Go5nZoueN8HW65vxHhmWdZw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 12 May 2017 12:36:00 -0700
Message-ID: <CAGXu5j+Gn3nSUinvDB+0aFo192UFtmNvu7o4Ma95-FzfMKCi2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH 01/18] gcc-plugins: Add the
 randstruct plugin
To: Loganaden Velvindron <loganaden@gmail.com>
Cc: Jessica Yu <jeyu@redhat.com>, Michael Leibowitz <michael.leibowitz@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 11, 2017 at 11:37 PM, Loganaden Velvindron
<loganaden@gmail.com> wrote:
> I often see drivers for android phones have all kinds of security
> issues. Does this help to make it harder to exploit vulnerabilities
> and RCEs in wifi drivers for example ?

Depends on the flaw (some of the recent wifi attacks have been against
the wifi firmware itself). As documented in the changelog:

... [randstruct is a] probabilistic defense against attacks that need
to know the layout of structures within the kernel ...

And overwriting function pointers in structures is a common way to
perform attacks, which this plugin would complicate. See "executing
code" in: https://googleprojectzero.blogspot.com/2017/05/exploiting-linux-kernel-via-packet.html

-Kees

-- 
Kees Cook
Pixel Security
