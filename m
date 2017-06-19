From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 13:56:37 -0700
Message-Id: <1497905801-69164-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v3 0/4] randstruct: Enable function pointer struct detection
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This continues the randstruct series (which is in -next now), and adds
explicit task_struct randomization and enables automatic structure
randomization.

The randstruct plugin (in -next), the marking of task_struct, and the
opt-out markings are modified from Brad Spengler/PaX Team's code in the
last public patch of grsecurity/PaX based on my understanding of the
code. Changes or omissions from the original code are mine and don't
reflect the original grsecurity/PaX code.

-Kees
