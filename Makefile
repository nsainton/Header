# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nsainton <nsainton@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/03/30 11:32:59 by nsainton          #+#    #+#              #
#    Updated: 2023/04/09 09:53:16 by nsainton         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME:= header

PROG:= $(NAME).c

SRCS_DIR:= sources

SRCS_SUBDIRS:= $(shell find $(SRCS_DIR) -type d)

SRCS_NAMES:= $(subst $(SRCS_DIR)/,, $(foreach dir, $(SRCS_SUBDIRS), $(wildcard $(dir)/*.c)))

SRCS:= $(addprefix $(SRCS_DIR)/, $(SRCS_NAMES))

INCS_DIR:= includes

OBJS_DIR:= objects

OBJS_NAMES:= $(SRCS_NAMES:.c=.o)

OBJS:= $(addprefix $(OBJS_DIR)/, $(OBJS_NAMES))

DEPS_DIR:= dependencies

DEPS:= $(patsubst %.c, $(DEPS_DIR)/%.d, $(SRCS_NAMES) $(PROG))

CC= clang

CFLAGS= -Wall -Wextra -Werror

GITADD= --all

LFT_DIR:= libft

ARCHITECTURE= $(shell uname)

export C_INCLUDE_PATH= $(INCS_DIR):$(LFT_DIR)/$(INCS_DIR)
export LIBRARY_PATH= $(LFT_DIR)

.DEFAULT_GOAL := all

makedebug:
	@echo $(DEPS)

all:
	$(MAKE) -C $(LFT_DIR)
	$(MAKE) $(NAME)

$(NAME): $(OBJS) | $(DEPS_DIR)
	$(CC) $(CFLAGS) $(OPT) $(GG) $(OBJS) $(PROG) -MD -MF $(DEPS_DIR)/$(PROG:.c=.d) -lft -o $(NAME)

$(DEPS_DIR):
	mkdir $(DEPS_DIR)

$(OBJS_DIR)/%.o: $(SRCS_DIR)/%.c Makefile
	[ -d $(@D) ] || mkdir -p $(@D)
	arg="$$(dirname $(DEPS_DIR)/$*)"; \
	[ -d $$arg ] || mkdir -p $$arg
	$(CC) $(CFLAGS) $(OPT) $(GG) -MD -MF $(DEPS_DIR)/$*.d -c $< -o $@

.PHONY: clean
clean:
	$(RM) -r $(DEPS_DIR)
	$(RM) -r $(OBJS_DIR)
	[ "$(ARCHITECTURE)" = "Darwin" ] && $(RM) -r *.dSYM || true

.PHONY: oclean
oclean:
	$(RM) $(NAME)

.PHONY: fclean
fclean:
	$(MAKE) clean
	$(MAKE) oclean

.PHONY: re
re:
	$(MAKE) fclean
	$(MAKE)

.PHONY: debug
debug:
	$(MAKE) fclean
	$(MAKE) CC=gcc GG=-g3 OPT=-O0

.PHONY: git
git:
	git add $(GITADD)
	git commit
	git push

-include $(DEPS)