MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jJHRC83YSDKVfm4_41k0wgqfG=wpqPQss-ce77SRNkwRA@mail.gmail.com>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-5-git-send-email-keescook@chromium.org> <CAK8P3a0beV+ZUUKxzufXtZRszbXvgC3eQO4Rc1+ZYo_nAmcaaA@mail.gmail.com>
 <CAGXu5jJHRC83YSDKVfm4_41k0wgqfG=wpqPQss-ce77SRNkwRA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 29 Jun 2017 17:04:46 -0700
Message-ID: <CAGXu5j+P7Sj99DdYE0mL1fjzVUoK6qntJXhSLk-vnKhHjejd7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 04/20] gcc-plugins: Add the randstruct plugin
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 29, 2017 at 3:53 PM, Kees Cook <keescook@chromium.org> wrote:
> I see a few possible solutions:

Or this ugly hack:

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e2ad3531e7fe..5d131f9f1dac 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -749,6 +749,19 @@ struct task_struct {
        /* Namespaces: */
        struct nsproxy                  *nsproxy;

+#ifdef CONFIG_ARM
+       /*
+        * Since task_struct is gigantic, some asmoffset locations
+        * (e.g. TSK_STACK_CANARY) for a randomized field may exceed
+        * an architecture's instruction immediate values. As a
+        * work-around to avoid changing the performance characteristics
+        * of the assembly, split the randomization into two groups,
+        * keeping the "early" fields within range of the immediates.
+        */
+       randomized_struct_fields_end
+       randomized_struct_fields_start
+#endif
+
        /* Signal handlers: */
        struct signal_struct            *signal;
        struct sighand_struct           *sighand;


I suspect updating the ARM assembly (CONFIG-conditionally) to accept
>4095 offsets is probably the best solution.

-Kees

-- 
Kees Cook
Pixel Security
