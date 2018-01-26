From: Cao jin <caoj.fnst@cn.fujitsu.com>
Message-ID: <daf68dfa-64ae-2aad-1237-fc9b7b7b6593@cn.fujitsu.com>
Date: Fri, 26 Jan 2018 16:32:19 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] A problem met when using crash with randomized kernel
To: keescook@chromium.org, re.emese@gmail.com
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Petr Tesarik <ptesarik@suse.cz>, Dave Anderson <anderson@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,
  Recently I am testing crash tool with structure layout randomized
kernel, and crash failed to work with it.

When using "gdb vmlinux"to examine both the randomized and
non-randomized vmlinux's debuginfo, take struct uts_namespace for
example, the output of "ptype struct uts_namespace" is identical in both
debuginfo.  And this causes a big trouble to crash utility, because
crash uses the embedded gdb to retrieve some structure member's offset
in debuginfo, and crash got the same offset value for every structure
member in both condition.

It is believed by gcc maintainer[*] that it is a problem of the plugin,
not gcc

[*]https://gcc.gnu.org/bugzilla/show_bug.cgi?id=84052

So, could you confirm it is plugin bug or not?
-- 
Sincerely,
Cao jin
