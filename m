Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Fri, 09 Dec 2016 11:59:42 +0100
MIME-Version: 1.0
Message-ID: <584A8E9E.22035.590FC72@pageexec.freemail.hu>
In-reply-to: <f5ea8825-532c-93bd-d51d-6ec1e541fae6@au1.ibm.com>
References: <20161206062800.21800-1-andrew.donnellan@au1.ibm.com>, <CAGXu5jKrU5GR3KDb9M-vtSpY+aRm2B0vGpahVYLtFTWs=g7Big@mail.gmail.com>, <f5ea8825-532c-93bd-d51d-6ec1e541fae6@au1.ibm.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH 3/3] powerpc: enable support for GCC plugins
To: Kees Cook <keescook@chromium.org>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 9 Dec 2016 at 13:48, Andrew Donnellan wrote:

> >> as for the solutions, the general advice should enable the use of otherwise
> >> failing gcc versions instead of forcing updating to new ones (though the
> >> latter is advisable for other reasons but not everyone's in the position to
> >> do so easily). in my experience all one needs to do is manually install the
> >> missing files from the gcc sources (ideally distros would take care of it).
> 
> If someone else is willing to write up that advice, then great.
> 
> >> the specific problem addressed here can (and IMHO should) be solved in
> >> another way: remove the inclusion of the offending headers in gcc-common.h
> >> as neither tm.h nor c-common.h are needed by existing plugins. for background,
> 
> We can't build without tm.h: http://pastebin.com/W0azfCr0

you'll need to repeat the removal of dependent headers. based on a quick
test here across gcc 4.5-6.2, if you remove rtl.h, tm_p.h, hard-reg-set.h
and emit-rtl.h in addition to tm.h, the plugins should build fine.

> And we get warnings without c-common.h: http://pastebin.com/Aw8CAj10

that's not due to c-common.h. gcc versions 4.5-4.6 are compiled as a C program
and gcc 4.7 can be compiled both as a C and a C++ program (IIRC, distros opted
for the latter, i forget what manually built versions default to but i guess you
went with the C compilation for your gcc anyway). couple that with -Wmissing-prototypes
and you get that warning regardless of c-common.h being included. something like
this should fix it:

--- a/scripts/gcc-plugins/gcc-generate-gimple-pass.h 2016-12-06 01:01:54.521724573 +0100
+++ b/scripts/gcc-plugins/gcc-generate-gimple-pass.h      2016-12-09 11:43:32.225226164 +0100
@@ -136,6 +136,7 @@
        return new _PASS_NAME_PASS();
 }
 #else
+struct opt_pass *_MAKE_PASS_NAME_PASS(void);
 struct opt_pass *_MAKE_PASS_NAME_PASS(void)
 {
        return &_PASS_NAME_PASS.pass;

> These were all manually built using a script running on a Debian box. 
> Installing precompiled distro versions of rather old gccs would have 
> been somewhat challenging. I've just rebuilt 4.6.4 to double check that 
> I wasn't just seeing things, but it seems that it definitely is still 
> putting c-common.h in the old location.

for reference, this is the git commit that did the move:

commit 7bedc3a05d34cd81e4835a2d3ff8c0ec7108eeb5
Author: steven <steven@138bc75d-0d04-0410-961f-82ee72b054a4>
Date:   Sat Jun 5 20:33:22 2010 +0000

    gcc/ChangeLog:
            * c-common.c: Move to c-family/.
            * c-common.def: Likewise.
            * c-common.h: Likewise.
